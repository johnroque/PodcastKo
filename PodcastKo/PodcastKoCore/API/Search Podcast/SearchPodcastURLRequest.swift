//
//  SearchPodcastURLRequest.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/25/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public struct SearchPodcastURLRequest {
    private let url: URL
    private let term: String
    
    public init(url: URL, term: String) {
        self.url = url
        self.term = term
    }
    
    public var urlRequest: URLRequest {
        let queryItems = [URLQueryItem(name: "term", value: term),
                          URLQueryItem(name: "media", value: "podcast")]
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = queryItems
        
        var request = URLRequest(url: urlComponent!.url!) // TODO: Make this safe
        
        request.httpMethod = HTTPMethod.GET.rawValue
        
        return request
    }
}
