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
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: DownloadEpisodeUseCase, client: HTTPDownloadClientSpy) {
        let client = HTTPDownloadClientSpy()
        let sut = DownloadEpisodeGateway(client: client)
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
