//
//  EpisodesFKGatewayTests.swift
//  PodcastKoCoreTests
//
//  Created by John Roque Jorillo on 5/29/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import XCTest
import PodcastKoCore

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
        
        expect(sut, toCompleteWith: .failure(clientError)) {
            client.complete(with: clientError)
        }
    }
    
    func test_getEpisodes_deliversEpisodesOnClientResult() {
        let (sut, client) = makeSUT()
        
        let ep1 = makeFKEpisode(title: "title 1", pubDate: nil, description: "desc 1", author: "author 1", streamURL: nil, image: nil)
        let ep2 = makeFKEpisode(title: "title 2", pubDate: nil, description: "desc 2", author: "author 2", streamURL: nil, image: nil)
        
        expect(sut, toCompleteWith: .success([ep1.domain, ep2.domain])) {
            client.complete(with: [ep1.fk, ep2.fk])
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
    
    private func makeFKEpisode(title: String? = nil, pubDate: Date? = nil, description: String? = nil, author: String? = nil, streamURL: String? = nil, image: String? = nil) -> (fk: FKEpisode, domain: Episode) {
        let fk = FKEpisode(title: title, pubDate: pubDate, description: description, author: author, streamURL: streamURL, image: image)
        let domain = Episode(title: title, pubDate: pubDate, description: description, author: author, streamURL: streamURL, image: image)
        return (fk, domain)
    }
    
    private func expect(_ sut: EpisodesFKGateway, toCompleteWith expectedResult: EpisodesFKGateway.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.getEpisodes { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 2.0)
    }
    
    private class FeedKitClientSpy: EpisodeFeedKitClient {
        var requests: [URL] {
            messages.map { $0.url }
        }
        
        private var messages = [(url: URL, completion: (EpisodeFeedKitClient.Result) -> Void)]()
        
        func get(_ url: URL, completion: @escaping (EpisodeFeedKitClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        // MARK: - Helpers
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(with fkEpisodes: [FKEpisode], at index: Int = 0) {
            messages[index].completion(.success(fkEpisodes))
        }
    }
    
}
