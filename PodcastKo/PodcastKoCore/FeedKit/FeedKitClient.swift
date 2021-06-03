//
//  FeedKitClient.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/30/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public protocol EpisodeFeedKitClient {
    typealias Result = Swift.Result<[FKEpisode], Error>
    
    func get(_ url: URL, completion: @escaping (Result) -> Void)
}
