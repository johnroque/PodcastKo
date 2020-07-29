//
//  FKEpisode.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

struct FKEpisode {
    
    let title: String?
    let pubDate: Date?
    let description: String?
    
}

extension FKEpisode {
    
    func toDomain() -> Episode {
        return Episode(title: title, pubDate: pubDate, description: description)
    }
    
}
