//
//  URLSessionHTTPClientTests.swift
//  PodcastKoCoreTests
//
//  Created by John Roque Jorillo on 5/23/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import XCTest
import PodcastKoCore

class URLSessionHTTPClientTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let request = makeURLRequest(url: anyURL(), httpMethod: .GET)
        let exp = expectation(description: "Wait for completion")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, request.url)
            XCTAssertEqual(request.httpMethod, request.httpMethod)
            exp.fulfill()
        }
        
        makeSUT().get(request: request) { _ in }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    func test_cancelGetFromURLTask_cancelsURLRequest() {
        let request = makeURLRequest(url: anyURL(), httpMethod: .GET)
        let exp = expectation(description: "Wait for completion")
        
        let task = makeSUT().get(request: request) { result in
            switch result {
            case let .failure(error as NSError) where error.code == URLError.cancelled.rawValue:
                break
            default:
                XCTFail("Expected cancelled result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        task.cancel()
        wait(for: [exp], timeout: 2.0)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        return sut
    }
    
    private func makeURLRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        return urlRequest
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
}
