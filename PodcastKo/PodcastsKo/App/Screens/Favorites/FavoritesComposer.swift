//
//  FavoritesComposer.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit
import PodcastKoCore

final class FavoritesComposer {
    
    private init() {}
    
    static func composeWith() -> FavoritesViewController {
        let vc = FavoritesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        // Setup Api
        let apiClient = URLSessionHTTPDownloadClient(session: URLSession(configuration: .default))
        let gateway = DownloadEpisodeGateway(client: apiClient)
        
        let downloadsViewModel = DownloadViewModel(useCase: gateway,
                                                   userDefaults: AppUserDefaults.shared)
        
        vc.viewModel = FavoritesViewViewModel(userDefaults: AppUserDefaults.shared,
                                              downloadViewModel: downloadsViewModel)
        
        return vc
    }
    
}
