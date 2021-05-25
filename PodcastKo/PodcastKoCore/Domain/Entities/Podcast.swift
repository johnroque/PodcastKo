//
//  Podcast.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public struct Podcast: Equatable {
    public let trackName: String?
    public let artistName: String?
    public let artworkUrl600: String?
    public let trackCount: Int?
    public let feedUrl: String?
    
    public init(trackName: String?, artistName: String?, artworkUrl600: String?, trackCount: Int?, feedUrl: String?) {
        self.trackName = trackName
        self.artistName = artistName
        self.artworkUrl600 = artworkUrl600
        self.trackCount = trackCount
        self.feedUrl = feedUrl
    }
}
