//
//  URLSessionHTTPDownloadClient.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 6/1/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public final class URLSessionHTTPDownloadClient: HTTPDownloadClient {
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
    
    public func download(request: URLRequest, progressHandler: ((Double) -> Void)?, completionHandler: @escaping (DownloadResult) -> Void) -> HTTPClientTask {
        let task = session.downloadTask(with: request) { (tmpUrl, response, error) in
            completionHandler(DownloadResult {
                if let error = error {
                    throw error
                } else if let tmpUrl = tmpUrl, let response = response as? HTTPURLResponse {
                    let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    
                    guard let originalName = request.url?.lastPathComponent else  {
                        throw UnexpectedValuesRepresentation()
                    }
                    
                    let savedURL = documentsURL.appendingPathComponent(originalName)
                    
                    try FileManager.default.moveItem(at: tmpUrl, to: savedURL)
                    return (savedURL, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task, progressBlock: progressHandler)
    }
}
