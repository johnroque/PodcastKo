//
//  URLSessionHTTPClient.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    private struct UnexpectedValuesRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        let progressBlock: ((Double) -> Void)?
        private var observation: NSKeyValueObservation?
        
        init(wrapped: URLSessionTask, progressBlock: ((Double) -> Void)? = nil) {
            self.wrapped = wrapped
            self.progressBlock = progressBlock
            
            setupProgressObservation()
        }
        
        private mutating func setupProgressObservation() {
            observation = wrapped.progress.observe(\.fractionCompleted, changeHandler: { [self] progress, _ in
                self.progressBlock?(progress.fractionCompleted)
            })
        }
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public func get(request: URLRequest, completionHandler: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            completionHandler(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                }
                throw UnexpectedValuesRepresentation()
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}

extension URLSessionHTTPClient: HTTPDownloadClient {
    public func download(request: URLRequest, progressHandler: ((Double) -> Void)?, completionHandler: @escaping (DownloadResult) -> Void) -> HTTPClientTask {
        let task = session.downloadTask(with: request) { (tmpUrl, response, error) in
            completionHandler(DownloadResult {
                if let error = error {
                    throw error
                } else if let tmpUrl = tmpUrl, let response = response as? HTTPURLResponse {
                    return (tmpUrl, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task, progressBlock: progressHandler)
    }
}
