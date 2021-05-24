//
//  SearchPodcastAPIMapper.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/25/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

internal final class SearchPodcastAPIMapper {
    private struct Root: Decodable {
        let resultCount: Int
        let results: [APIPodcast]
    }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [APIPodcast] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw SearchPodcastAPIGateway.Error.invalidData
        }
        
        return root.results
    }
}
