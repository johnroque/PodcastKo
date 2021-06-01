//
//  FavoritesViewViewModel.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 8/5/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation
import PodcastKoCore

final class FavoritesViewViewModel {
    
    let userDefaults: AppUserDefaults
    let downloadViewModel: DownloadViewModelInputs
    
    init(userDefaults: AppUserDefaults, downloadViewModel: DownloadViewModelInputs) {
        self.userDefaults = userDefaults
        self.downloadViewModel = downloadViewModel
    }
    
    func getFavoritePodcasts() -> [Podcast] {
        
        guard let podcasts = self.userDefaults.getObjectWithKey(.favoritedPodcastKey, type: [Podcast].self) else {
            return []
        }
        
        return podcasts
    }

    func saveNewPodcasts(podcasts: [Podcast]) {
        
        self.userDefaults.removeDefaultsWithKey(.favoritedPodcastKey)
        
        self.userDefaults.store(podcasts, key: .favoritedPodcastKey)
        
    }
    
}
