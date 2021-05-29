//
//  EpisodesFKGatewayTests.swift
//  PodcastKoCoreTests
//
//  Created by John Roque Jorillo on 5/29/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import XCTest
import PodcastKoCore

public protocol FeedKitClient {
    typealias Result = Swift.Result<[FKEpisode], Error>
    
    func get(_ url: URL, completion: @escaping (Result) -> Void)
}

public struct FKEpisode {
    public let title: String?
    public let pubDate: Date?
    public let description: String?
    public let author: String?
    public let streamUrl: String?
    
    public let image: String?
}

public final class EpisodesFKGateway: GetEpisodesUseCase {
    
    private let client: FeedKitClient
    private let url: URL
    
    public init(client: FeedKitClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func getEpisodes(completionHandler: @escaping CompletionHandler) {
        client.get(self.url) { _ in }
    }
}

class EpisodesFKGatewayTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requests.isEmpty)
    }
    
    func test_getEpisodes_requestsDataFromGivenURL() {
        let requestURL = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: requestURL)
        
        sut.getEpisodes() { _ in }
        
        XCTAssertEqual(client.requests, [requestURL])
    }
    
    func test_getEpisodesTwice_requestDaaFromURLTwice() {
        let requestURL = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: requestURL)
        
        sut.getEpisodes() { _ in }
        sut.getEpisodes() { _ in }
        
        XCTAssertEqual(client.requests, [requestURL, requestURL])
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = anyURL(), file: StaticString = #filePath, line: UInt = #line) -> (sut: EpisodesFKGateway, client: FeedKitClientSpy) {
        let client = FeedKitClientSpy()
        let sut = EpisodesFKGateway(client: client, url: url)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
    }
    
    private class FeedKitClientSpy: FeedKitClient {
        var requests: [URL] {
            messages.map { $0.url }
        }
        
        private var messages = [(url: URL, completion: (FeedKitClient.Result) -> Void)]()
        
        func get(_ url: URL, completion: @escaping (FeedKitClient.Result) -> Void) {
            messages.append((url, completion))
        }
    }
    
}
