//
//  DownloadEpisodeApiRequest.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 12/27/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

struct DownloadEpisodeApiRequest: URLSessionRequest {
    
    var url: URL
    
    var urlRequest: URLRequest {
        let request = URLRequest(url: url)
        
        return request
    }
    
}
