//
//  EpisodesViewViewModel.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

final class EpisodesViewViewModel {
    
    let getEpisodesViewModel: GetEpisodesViewModelInputs
    let userDefaults: AppUserDefaults
    
    init(getEpisodesViewModel: GetEpisodesViewModelInputs, userDefaults: AppUserDefaults) {
        self.getEpisodesViewModel = getEpisodesViewModel
        self.userDefaults = userDefaults
    }
    
    func saveFavoritePodcast(podcast: Podcast) {
        
        var podcasts: [Podcast] = getFavoritePodcasts()
        podcasts.append(podcast)
        
        self.userDefaults.store(podcasts, key: .favoritedPodcastKey)
        
    }
    
    func getFavoritePodcasts() -> [Podcast] {
        
        guard let podcasts = self.userDefaults.getObjectWithKey(.favoritedPodcastKey, type: [Podcast].self) else {
            return []
        }
        
        return podcasts
    }
    
}
