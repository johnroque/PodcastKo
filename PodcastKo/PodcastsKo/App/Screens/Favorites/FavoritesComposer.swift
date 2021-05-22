//
//  FavoritesComposer.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit

final class FavoritesComposer {
    
    private init() {}
    
    static func composeWith() -> FavoritesViewController {
        let vc = FavoritesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        // Setup Api
        let apiLogger = ApiLogger()
        let apiClient = URLSessionHttpClient(session: URLSession(configuration: .default), logger: apiLogger)
        let apiEpisodeGateway = ApiEpisodeGatewayImpl(client: apiClient)
        
        let downloadsViewModel = DownloadViewModel(useCase: apiEpisodeGateway,
                                                   userDefaults: AppUserDefaults.shared)
        
        vc.viewModel = FavoritesViewViewModel(userDefaults: AppUserDefaults.shared,
                                              downloadViewModel: downloadsViewModel)
        
        return vc
    }
    
}
