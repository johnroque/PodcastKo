//
//  ApiEpisodeGateway.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 12/27/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

protocol ApiEpisodeGateway: DownloadEpisodeUseCase {
}

class ApiEpisodeGatewayImpl: BaseApiGateway, DownloadEpisodeUseCase {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func downloadEpisode(url: URL,
                         progressHandler: ((Double) -> Void)?,
                         completionHandler: @escaping DownloadEpisodeUseCaseCompletionHandler) -> HttpClientTask {
        
        let request = DownloadEpisodeApiRequest(url: url)
        
        return self.client.download(request: request,
                                    progressHandler: progressHandler) { (result) in
            
            switch result {
            case .success(let response):
                completionHandler(.success(response.0))
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        }
        
    }
    
}
