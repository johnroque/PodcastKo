//
//  PodcastGateway.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/28/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

protocol ApiPodcastGateway: SearchPodcastUseCase {
}

class ApiPodcastGatewayImpl: BaseApiGateway, ApiPodcastGateway {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func searchPodcast(title: String,
                       completionHandler: @escaping SearchPodcaseUseCaseCompletionHandler) -> HttpClientTask {
        
        let request = SearchPodcastApiRequest(title: title)
        
        return self.client.get(request: request) { (result) in
            
            switch result {
            case let .success((data, response)):
                completionHandler(SearchPodcastApiMapper.toModels(data, from: response))
            case .failure:
                completionHandler(.failure(Error.connectivity))
            }
            
        }
        
    }
    
}
