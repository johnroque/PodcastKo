//
//  EpisodesComposer.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

final class EpisodesComposer {
    
    private init() {}
    
    static func composeWith(podCast: Podcast) -> EpisodesViewController {
        let vc = EpisodesViewController()
        vc.podCast = podCast
        return vc
    }
    
}
