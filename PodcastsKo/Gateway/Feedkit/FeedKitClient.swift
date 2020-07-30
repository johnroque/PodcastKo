//
//  FeedKitClient.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation
import FeedKit

final class FeedKitClientImp {
    
    private struct UnsupportedParse: Error {}
    
    func parse(url: URL, completionHandler: @escaping (Result<[FKEpisode], Error>) -> Void) {
        let parser = FeedParser(URL: url)
        parser.parseAsync { (result) in
            
            completionHandler(Result {
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
                                                  image: imageUrl))
                    })
                    return episodes
                default:
                    throw UnsupportedParse()
                }
                
            case .failure:
                throw UnsupportedParse()
            }
            })
            
        }
        
    }
    
//    func parse(url: URL) {
//        let parser = FeedParser(URL: url)
//        parser.parseAsync { (result) in
//
//            switch result {
//            case .success(let feed):
//
//                switch feed {
//                case let .atom(atomFeed):
//                    break
//                case let .json(jsonFeed): break
//                case let .rss(rssFeed): break
//                }
//
//            case .failure(let error):
//                break
//            }
//
//        }
//    }
    
}
