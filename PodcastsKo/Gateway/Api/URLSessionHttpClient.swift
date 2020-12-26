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
    
    private class URLSessionTaskWrapper: HttpClientTask {
        let wrapped: URLSessionTask
        var progressBlock: ((Double) -> Void)?
        private var observation: NSKeyValueObservation?
        
        init(wrapped: URLSessionTask,
             progressBlock: ((Double) -> Void)? = nil) {
            
            self.wrapped = wrapped
            self.progressBlock = progressBlock
            
            setupProgressObservation()
        }
        
        private func setupProgressObservation() {
            observation = wrapped.progress.observe(\.fractionCompleted,
                                                   changeHandler: { [weak self] (progress, _) in
                                                    self?.progressBlock?(progress.fractionCompleted)
                                                   })
        }
        
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
    
    func download(request: URLSessionRequest,
                  progressHandler: ((Double) -> Void)?,
                  completionHandler: @escaping (HTTPClient.DownloadResult) -> Void) -> HttpClientTask {
        
        self.apiLogger.log(request: request.urlRequest)
        
        let task = session.downloadTask(with: request.urlRequest) { (url, response, error) in
            
            
            completionHandler(DownloadResult {
                if let error = error {
                    throw error
                } else if let url = url, let response = response as? HTTPURLResponse {
                    do {
                        let documentsUrl = try FileManager.default.url(for: .documentDirectory,
                                                                       in: .userDomainMask,
                                                                       appropriateFor: nil,
                                                                       create: false)
                        guard let originalName = request.urlRequest.url?.lastPathComponent else {
                            throw UnexpectedValuesRepresentation()
                        }
                        let savedUrl = documentsUrl.appendingPathComponent(originalName)
                        
                        try FileManager.default.moveItem(at: url, to: savedUrl)
                        return (savedUrl, response)
                    } catch {
                        throw UnexpectedValuesRepresentation()
                    }
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
            
        }
        
        task.resume()
        return URLSessionTaskWrapper(wrapped: task, progressBlock: progressHandler)
    }
    
}
