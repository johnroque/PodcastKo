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
            case let .success(fkEpisods):
                completion(.success(fkEpisods.toDomain()))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension Array where Element == FKEpisode {
    func toDomain() -> [Episode] {
        self.map { Episode(title: $0.title,
                           pubDate: $0.pubDate,
                           description: $0.description,
                           author: $0.author,
                           streamURL: $0.streamUrl,
                           image: $0.image) }
    }
}
