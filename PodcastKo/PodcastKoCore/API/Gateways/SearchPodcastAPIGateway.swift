//
//  SearchPodcastAPIGateway.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/25/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public final class SearchPodcastAPIGateway: SearchPodcastUseCase {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
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
    
    public func searchPodcast(title: String, completion: @escaping (SearchPodcastUseCase.Result) -> Void) -> CancellableTask {
        let request = SearchPodcastURLRequest(url: url, term: title)
        
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = self.client.get(request: request.urlRequest, completionHandler: { result in
            switch result {
            case let .success((_, httpResponse)):
                if httpResponse.isOK {
                    completion(.success([]))
                } else {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        })
        return task
    }
}
