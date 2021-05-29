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
    
    public init(client: FeedKitClient) {
        self.client = client
    }
    
    public func getEpisodes(url: URL, completionHandler: @escaping CompletionHandler) {
        client.get(url) { _ in }
    }
}

class EpisodesFKGatewayTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requests.isEmpty)
    }
    
    func test_getEpisodes_requestsDataFromGivenURL() {
        let (sut, client) = makeSUT()
        let requestURL = anyURL()
        
        sut.getEpisodes(url: requestURL) { _ in }
        
        XCTAssertEqual(client.requests, [requestURL])
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: EpisodesFKGateway, client: FeedKitClientSpy) {
        let client = FeedKitClientSpy()
        let sut = EpisodesFKGateway(client: client)
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
