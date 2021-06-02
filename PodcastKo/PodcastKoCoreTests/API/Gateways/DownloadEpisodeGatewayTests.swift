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
        let client = HTTPDownloadClientSpy()
        _ = DownloadEpisodeGateway(client: client)
        
        XCTAssertTrue(client.requests.isEmpty)
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
