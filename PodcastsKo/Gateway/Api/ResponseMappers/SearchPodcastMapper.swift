//
//  SearchPodcastMapper.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/28/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

final class SearchPodcastApiMapper {
    
    struct Root: Decodable {
        let resultCount: Int
        let results: [ApiPodcast]
    }
    
    static func toModels(_ data: Data, from response: HTTPURLResponse) -> Result<[Podcast], Error> {
        do {
            let results = try map(data, from: response)
            return .success(results.toModels())
        } catch {
            return .failure(error)
        }
    }
    
    static private func map(_ data: Data, from response: HTTPURLResponse) throws -> [ApiPodcast] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw ApiPodcastGatewayImpl.Error.invalidData
        }
        
        return root.results
    }
    
}

extension Array where Element == ApiPodcast {
    
    func toModels() -> [Podcast] {
        return map { Podcast(trackName: $0.trackName,
                             artistName: $0.artistName,
                             artworkUrl600: $0.artworkUrl600,
                             trackCount: $0.trackCount,
                             feedUrl: $0.feedUrl) }
    }
    
}
