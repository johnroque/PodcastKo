//
//  DownloadEpisodeURLRequest.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 6/1/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public struct DownloadEpisodeURLRequest {
    private let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public var urlRequest: URLRequest {
        let request = URLRequest(url: url)
        return request
    }
}
