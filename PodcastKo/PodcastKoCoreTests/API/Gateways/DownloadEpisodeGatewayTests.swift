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
        
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.downloadEpisode(
            url: anyURL(),
            progressHandler: nil) { result in
            
            switch result {
            case let .failure(error as NSError):
                XCTAssertEqual(error, clientError)
            default:
                XCTFail("Expected failure, got \(result) instead.")
            }
            
            exp.fulfill()
        }
        
        client.complete(with: clientError)
        
        wait(for: [exp], timeout: 2.0)
    }
    
    func test_download_deliversDownloadURLOnDownloadRequestSucceeds() {
        let downloadedURL = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT()
        
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.downloadEpisode(
            url: anyURL(),
            progressHandler: nil) { result in
            
            switch result {
            case let .success(url):
                XCTAssertEqual(url, downloadedURL)
            default:
                XCTFail("Expected result, got \(result) instead.")
            }
            
            exp.fulfill()
        }
        
        client.complete(withStatusCode: 200, url: downloadedURL)
        
        wait(for: [exp], timeout: 2.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: DownloadEpisodeUseCase, client: HTTPDownloadClientSpy) {
        let client = HTTPDownloadClientSpy()
        let sut = DownloadEpisodeGateway(client: client)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
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
    }
    
}
