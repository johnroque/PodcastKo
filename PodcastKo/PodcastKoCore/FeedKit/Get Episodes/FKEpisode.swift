//
//  FKEpisode.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/30/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public struct FKEpisode {
    public let title: String?
    public let pubDate: Date?
    public let description: String?
    public let author: String?
    public let streamUrl: String?
    
    public let image: String?
    
    public init(title: String?, pubDate: Date?, description: String?, author: String?, streamURL: String?, image: String?) {
        self.title = title
        self.pubDate = pubDate
        self.description = description
        self.author = author
        self.streamUrl = streamURL
        self.image = image
    }
}
