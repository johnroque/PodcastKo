//
//  Episode.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public struct Episode: Equatable {
    
    let title: String?
    let pubDate: Date?
    let description: String?
    let author: String?
    let streamUrl: String?
    let image: String?
    
    var fileUrl: String?
    
}
