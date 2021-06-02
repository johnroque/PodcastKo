//
//  DownloadEpisodeGatewayTests.swift
//  PodcastKoCoreTests
//
//  Created by John Roque Jorillo on 6/2/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import XCTest
import PodcastKoCore

class DownloadEpisodeGatewayTests: XCTestCase {
    
    func test_init_doesNotRequestDownloadFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requests.isEmpty)
    }
    
    func test_download_requestDownloadFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT()
        
        _ = sut.downloadEpisode(
            url: url,
            progressHandler: nil) { _ in }
        
        XCTAssertEqual(client.requests.map { $0.url }, [url])
    }
    
    func test_download_deliversErrorOnClientError() {
        let clientError = NSError(domain: "Test", code: 0)
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(clientError)) {
            client.complete(with: clientError)
        }
    }
    
    func test_download_deliversDownloadURLOnDownloadRequestSucceeds() {
        let downloadedURL = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success(downloadedURL)) {
            client.complete(withStatusCode: 200, url: downloadedURL)
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: DownloadEpisodeUseCase, client: HTTPDownloadClientSpy) {
        let client = HTTPDownloadClientSpy()
        let sut = DownloadEpisodeGateway(client: client)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
    }
    
    private func expect(_ sut: DownloadEpisodeUseCase, toCompleteWith expectedResult: DownloadEpisodeGateway.Completion, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        _ = sut.downloadEpisode(
            url: anyURL(),
            progressHandler: nil) { receivedResult in

            switch (receivedResult, expectedResult) {
            case let (.success(receivedURL), .success(expectedURL)):
                XCTAssertEqual(receivedURL, expectedURL, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 2.0)
    }
    
    private class HTTPDownloadClientSpy: HTTPDownloadClient {
        private struct Task: HTTPClientTask {
            func cancel() {}
        }
        
        var requests: [URLRequest] {
            messages.map { $0.request }
        }
        
        private var messages = [
            (request: URLRequest,
             progress: ((Double) -> Void)?,
             completion: (HTTPDownloadClient.DownloadResult) -> Void)]()
        
        func download(request: URLRequest, progressHandler: ((Double) -> Void)?, completionHandler: @escaping (DownloadResult) -> Void) -> HTTPClientTask {
            messages.append((request, progressHandler, completionHandler))
            return Task()
        }
        
        // MARK: - Helpers
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, url: URL, at index: Int = 0) {
            let response = HTTPURLResponse(url: messages[index].request.url!, // TODO: make this safe
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)
            
            messages[index].completion(.success((url, response!)))
        }
    }
    
}
