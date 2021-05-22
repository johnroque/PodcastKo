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
        
        let queryItems = [URLQueryItem(name: "term", value: title),
                          URLQueryItem(name: "media", value: "podcast")]
        var urlComponent = URLComponents(string: "https://itunes.apple.com/search")
        urlComponent?.queryItems = queryItems
        
        var request = URLRequest(url: urlComponent!.url!) // TODO: Make this safe
        
        request.httpMethod = HTTPMethod.GET.rawValue
        
        return request
    }
    
}

extension String {
    
    func escapedString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
}
