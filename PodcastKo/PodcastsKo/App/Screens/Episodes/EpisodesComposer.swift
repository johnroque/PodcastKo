//
//  EpisodesComposer.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation
import PodcastKoCore

final class EpisodesComposer {
    
    private init() {}
    
    static func composeWith(podCast: Podcast) -> EpisodesViewController {
        
        // setup FKClient
        let fkClient = FeedKitClientImpl()
        let fkGateway = EpisodesFKGateway(client: fkClient, url: URL(string: podCast.feedUrl!)!)
        
        // Setup Api
        let apiClient = URLSessionHTTPDownloadClient(session: URLSession(configuration: .default))
        let apiEpisodeGateway = DownloadEpisodeGateway(client: apiClient)
        
        // setup ViewModel
        let getEpisodesViewModel = GetEpisodesViewModel(useCase: fkGateway)
        let downloadsViewModel = DownloadViewModel(useCase: apiEpisodeGateway,
                                                   userDefaults: AppUserDefaults.shared)
        let episodesViewViewModel = EpisodesViewViewModel(getEpisodesViewModel: getEpisodesViewModel,
                                                          userDefaults: AppUserDefaults.shared,
                                                          downloadViewModel: downloadsViewModel)
        
        let vc = EpisodesViewController()
        vc.podCast = podCast
        vc.viewModel = episodesViewViewModel
        return vc
    }
    
}
