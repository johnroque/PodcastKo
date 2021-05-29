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
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(client: FeedKitClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func getEpisodes(completion: @escaping (GetEpisodesUseCase.Result) -> Void) {
        client.get(self.url) { _ in
            completion(.failure(Error.connectivity))
        }
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
    
    func test_getEpisodes_deliversErrorOnClientError() {
        let clientError = NSError(domain: "Test", code: 0)
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            client.complete(with: clientError)
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = anyURL(), file: StaticString = #filePath, line: UInt = #line) -> (sut: EpisodesFKGateway, client: FeedKitClientSpy) {
        let client = FeedKitClientSpy()
        let sut = EpisodesFKGateway(client: client, url: url)
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(sut)
        return (sut, client)
    }
    
    private func failure(_ error: EpisodesFKGateway.Error) -> EpisodesFKGateway.Result {
        EpisodesFKGateway.Result.failure(error)
    }
    
    private func expect(_ sut: EpisodesFKGateway, toCompleteWith expectedResult: EpisodesFKGateway.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.getEpisodes { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as EpisodesFKGateway.Error), .failure(expectedError as EpisodesFKGateway.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 2.0)
    }
    
    private class FeedKitClientSpy: FeedKitClient {
        var requests: [URL] {
            messages.map { $0.url }
        }
        
        private var messages = [(url: URL, completion: (FeedKitClient.Result) -> Void)]()
        
        func get(_ url: URL, completion: @escaping (FeedKitClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        // MARK: - Helpers
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
    }
    
}
