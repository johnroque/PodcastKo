//
//  FavoritesViewViewModel.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 8/5/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

final class FavoritesViewViewModel {
    
    let userDefaults: AppUserDefaults
    
    init(userDefaults: AppUserDefaults) {
        self.userDefaults = userDefaults
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
