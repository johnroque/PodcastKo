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
        
        // setup FKClient
        let fkClient = FeedKitClientImp()
        let fkGateway = FKGatewayImpl(client: fkClient)
        
        // setup ViewModel
        let getEpisodesViewModel = GetEpisodesViewModel(useCase: fkGateway)
        let episodesViewViewModel = EpisodesViewViewModel(getEpisodesViewModel: getEpisodesViewModel, userDefaults: AppUserDefaults.shared)
        
        let vc = EpisodesViewController()
        vc.podCast = podCast
        vc.viewModel = episodesViewViewModel
        return vc
    }
    
}
