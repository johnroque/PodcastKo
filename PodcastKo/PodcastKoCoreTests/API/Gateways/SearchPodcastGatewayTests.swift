//
//  SearchPodcastGatewayTests.swift
//  PodcastKoCoreTests
//
//  Created by John Roque Jorillo on 5/24/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import XCTest
import PodcastKoCore

struct SearchPodcastURLRequest {
    let url: URL
    let term: String
    
    var urlRequest: URLRequest {
        let queryItems = [URLQueryItem(name: "term", value: term),
                          URLQueryItem(name: "media", value: "podcast")]
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = queryItems
        
        var request = URLRequest(url: urlComponent!.url!) // TODO: Make this safe
        
        request.httpMethod = HTTPMethod.GET.rawValue
        
        return request
    }
}

final class SearchPodcastAPIGateway: SearchPodcastUseCase {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    private final class HTTPClientTaskWrapper: CancellableTask {
        private var completion: ((SearchPodcastUseCase.Result) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (SearchPodcastUseCase.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: SearchPodcastUseCase.Result) {
            completion?(result)
        }
        
        func cancel() {
            completion = nil
            wrapped?.cancel()
        }
    }
    
    func searchPodcast(title: String, completion: @escaping (SearchPodcastUseCase.Result) -> Void) -> CancellableTask {
        let request = SearchPodcastURLRequest(url: url, term: title)
        
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = self.client.get(request: request.urlRequest, completionHandler: { _ in })
        return task
    }
}

class SearchPodcastGatewayTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requests.isEmpty)
    }
    
    func test_searchPodcast_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let title = makeTitle()
        let requestedURL = makeSearchPodcastRequest(url: url, term: title)
        let (sut, client) = makeSUT(url: url)
        
        _ = sut.searchPodcast(title: title) { _ in }

        XCTAssertEqual(client.requests.map { $0.url }, [requestedURL.urlRequest.url])
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
    
    private func makeTitle() -> String {
        "title"
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
    }
    
}


