//
//  DownloadsComposer.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

final class DownloadsComposer {
    
    private init() {}
    
    static func composeWith() -> DownloadsViewController {
        let vc = DownloadsViewController()
        
        // Setup Api
        let apiLogger = ApiLogger()
        let apiClient = URLSessionHttpClient(session: URLSession(configuration: .default), logger: apiLogger)
        let apiEpisodeGateway = ApiEpisodeGatewayImpl(client: apiClient)
        
        // setup ViewModel
        let downloadsViewModel = DownloadViewModel(useCase: apiEpisodeGateway,
                                                   userDefaults: AppUserDefaults.shared)
        let downloadUIViewModel = DownloadsViewViewModel(downloadViewModel: downloadsViewModel)
        
        vc.viewModel = downloadUIViewModel
        
        return vc
    }
    
}
