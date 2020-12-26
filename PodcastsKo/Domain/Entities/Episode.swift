//
//  Episode.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

struct Episode: Codable {
    
    let title: String?
    let pubDate: Date?
    let description: String?
    let author: String?
    let streamUrl: String?
    let image: String?
    
    var fileUrl: String?
    
}
