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
        
    }
}

class EpisodesFKGatewayTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = FeedKitClientSpy()
        let _ = EpisodesFKGateway(client: client)
        
        XCTAssertTrue(client.requests.isEmpty)
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
