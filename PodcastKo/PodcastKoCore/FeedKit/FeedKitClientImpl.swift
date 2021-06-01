//
//  FeedKitClientImpl.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/30/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation
import FeedKit

public final class FeedKitClientImpl: EpisodeFeedKitClient {
    
    private struct UnsupportedParse: Error {}
    
    public init() {}
    
    public func get(_ url: URL, completion: @escaping (EpisodeFeedKitClient.Result) -> Void) {
        let parser = FeedParser(URL: url)
        parser.parseAsync { (result) in
            completion(Result {
            switch result {
            case .success(let feed):
                switch feed {
                case let .rss(rssFeed):
                    var imageUrl = rssFeed.iTunes?.iTunesImage?.attributes?.href
                    
                    var episodes = [FKEpisode]()
                    rssFeed.items?.forEach({ (feedItem) in
                        
                        if feedItem.iTunes?.iTunesImage?.attributes?.href != nil {
                            imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
                        }
                        
                        episodes.append(FKEpisode(title: feedItem.title,
                                                  pubDate: feedItem.pubDate,
                                                  description: feedItem.iTunes?.iTunesSubtitle ?? feedItem.description,
                                                  author: feedItem.iTunes?.iTunesAuthor,
                                                  streamURL: feedItem.enclosure?.attributes?.url,
                                                  image: imageUrl))
                    })
                    return episodes
                default:
                    throw UnsupportedParse()
                }
                
            case let .failure(error):
                throw error
            }
            })
            
        }
    }
}
