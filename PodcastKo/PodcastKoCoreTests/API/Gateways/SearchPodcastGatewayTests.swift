//
//  SearchPodcastGatewayTests.swift
//  PodcastKoCoreTests
//
//  Created by John Roque Jorillo on 5/24/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import XCTest
import PodcastKoCore

class SearchPodcastGatewayTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requests.isEmpty)
    }
    
    func test_searchPodcast_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let title = makeTerm()
        let requestedURL = makeSearchPodcastRequest(url: url, term: title)
        let (sut, client) = makeSUT(url: url)
        
        _ = sut.searchPodcast(title: title) { _ in }

        XCTAssertEqual(client.requests.map { $0.url }, [requestedURL.urlRequest.url])
    }
    
    func test_searchPodcastTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let title = makeTerm()
        let requestedURL = makeSearchPodcastRequest(url: url, term: title)
        let (sut, client) = makeSUT(url: url)
        
        _ = sut.searchPodcast(title: title) { _ in }
        _ = sut.searchPodcast(title: title) { _ in }

        XCTAssertEqual(client.requests.map { $0.url }, [requestedURL.urlRequest.url, requestedURL.urlRequest.url])
    }
    
    func test_searchPodcast_deliversErrorOnClientError() {
        let clientError = NSError(domain: "Test", code: 0)
        let (sut, client) = makeSUT()
        
        expect(sut, term: makeTerm(), toCompleteWith: failure(.connectivity)) {
            client.complete(with: clientError)
        }
    }
    
    func test_searchPodcast_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 300, 400, 500].enumerated()
        
        samples.forEach { (index, code) in
            expect(sut, term: makeTerm(), toCompleteWith: failure(.invalidData)) {
                client.complete(withStatusCode: code, data: anyData(), at: index)
            }
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: SearchPodcastAPIGateway, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = SearchPodcastAPIGateway(url: url, client: client)
        
        return (sut, client)
    }
    
    private func makeSearchPodcastRequest(url: URL = URL(string: "https://a-url.com")!, term: String) -> SearchPodcastURLRequest {
        SearchPodcastURLRequest(url: url, term: term)
    }
    
    private func makeTerm() -> String {
        "term"
    }
    
    private func failure(_ error: SearchPodcastAPIGateway.Error) -> SearchPodcastAPIGateway.Result {
        SearchPodcastAPIGateway.Result.failure(error)
    }
    
    private func expect(_ sut: SearchPodcastAPIGateway, term: String, toCompleteWith expectedResult: SearchPodcastAPIGateway.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.searchPodcast(title: term) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as SearchPodcastAPIGateway.Error), .failure(expectedError as SearchPodcastAPIGateway.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 2.0)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private struct Task: HTTPClientTask {
            func cancel() {}
        }
        
        var requests: [URLRequest] {
            messages.map { $0.request }
        }
        
        private var messages = [(request: URLRequest, completion: (HTTPClient.Result) -> Void)]()
        
        func get(request: URLRequest, completionHandler: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            messages.append((request, completionHandler))
            return Task()
        }
        
        // MARK: - Helpers
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: messages[index].request.url!, // TODO: make this safe
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)
            
            messages[index].completion(.success((data, response!)))
        }
    }
}


