//
//  APIPodcast.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/25/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

internal struct APIPodcast: Decodable {
    internal let trackName: String?
    internal let artistName: String?
    internal let artworkUrl600: String?
    internal let trackCount: Int?
    internal let feedUrl: String?
}
