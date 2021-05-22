//
//  FKGateway.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

protocol FKGateway: GetEpisodesUseCase {
}

class FKGatewayImpl: FKGateway {
    
    let client: FeedKitClientImp
    
    init(client: FeedKitClientImp) {
        self.client = client
    }
    
    func getEpisodes(url: URL, completionHandler: @escaping GetEpisodesUseCaseCompletionHandler) {
        
        self.client.parse(url: url) { (result) in
            
            switch result {
            case .success(let fkEpisodes):
                let episodes = fkEpisodes.map { $0.toDomain() }
                completionHandler(.success(episodes))
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        }
        
    }
    
}
