//
//  DownloadEpisodeGateway.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 6/1/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public final class DownloadEpisodeGateway: DownloadEpisodeUseCase {
    private let client: HTTPDownloadClient
    
    public init(url: URL, client: HTTPDownloadClient) {
        self.client = client
    }
    
    private final class HTTPClientTaskWrapper: CancellableTask {
        private var completion: ((DownloadEpisodeUseCase.Completion) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (DownloadEpisodeUseCase.Completion) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: DownloadEpisodeUseCase.Completion) {
            completion?(result)
        }
        
        func cancel() {
            completion = nil
            wrapped?.cancel()
        }
    }
  
    func downloadEpisode(url: URL, progressHandler: ((Double) -> Void)?, completionHandler: @escaping (Completion) -> Void) -> CancellableTask {
        let request = DownloadEpisodeURLRequest(url: url)
        
        let task = HTTPClientTaskWrapper(completionHandler)
        task.wrapped = client.download(
            request: request.urlRequest,
            progressHandler: progressHandler,
            completionHandler: { result in
                
                switch result {
                case let .success((url, _)):
                    task.complete(with: .success(url))
                case let .failure(error):
                    task.complete(with: .failure(error))
                }
                
            })
        return task
    }
}
