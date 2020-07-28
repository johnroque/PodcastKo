//
//  URLSessionHttpClient.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/27/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

final class URLSessionHttpClient: HTTPClient {
    
    private let session: URLSession
    private let apiLogger: ApiLoggerable
    
    public init(session: URLSession, logger: ApiLoggerable) {
        self.session = session
        self.apiLogger = logger
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HttpClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    func get(request: URLSessionRequest, completionHandler: @escaping (HTTPClient.Result) -> Void) -> HttpClientTask {
        
        self.apiLogger.log(request: request.urlRequest)
        
        let task = session.dataTask(with: request.urlRequest) { [weak self] (data, response, error) in
            
            self?.apiLogger.log(data: data, response: response as? HTTPURLResponse, error: error)
            
            completionHandler(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
    
}
