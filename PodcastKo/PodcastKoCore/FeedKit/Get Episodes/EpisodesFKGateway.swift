//
//  EpisodesFKGateway.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/30/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public final class EpisodesFKGateway: GetEpisodesUseCase {
    
    private let client: EpisodeFeedKitClient
    private let url: URL
    
    public init(client: EpisodeFeedKitClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func getEpisodes(completion: @escaping (GetEpisodesUseCase.Result) -> Void) {
        client.get(self.url) { result in
            switch result {
            case .success:
                break
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
