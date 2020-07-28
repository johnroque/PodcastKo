//
//  SearchPodcastApiRequest.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/28/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

struct SearchPodcastApiRequest: URLSessionRequest {
    
    let title: String
    
    var urlRequest: URLRequest {
        
        let url = URL(string: "https://itunes.apple.com/search?term=\(title)")!
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.GET.rawValue
        
        return request
    }
    
}
