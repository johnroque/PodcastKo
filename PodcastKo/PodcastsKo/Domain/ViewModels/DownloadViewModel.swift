//
//  DownloadViewModel.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 9/3/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PodcastKoCore

protocol DownloadViewModelInputs {
    func getDownloads()
    func downloadEpisode(episode: Episode)
    func removeDownload(episode: Episode)
    func getOutputs() -> DownloadViewModelOutputs
}

protocol DownloadViewModelOutputs {
    var downloads: BehaviorRelay<[Episode]> { get }
}

final class DownloadViewModel: DownloadViewModelInputs, DownloadViewModelOutputs {
    
    private let useCase: DownloadEpisodeUseCase
    let userDefaults: AppUserDefaults
    
    private var downloadRequest: CancellableTask?
    
    init(useCase: DownloadEpisodeUseCase,
         userDefaults: AppUserDefaults) {
        self.useCase = useCase
        self.userDefaults = userDefaults
    }
    
    let downloads: BehaviorRelay<[Episode]> = BehaviorRelay(value: [])
    
    private func getDownloads() -> [Episode] {
        
        guard let episodes = self.userDefaults.getObjectWithKey(.downloadEpisodeKey, type: [Episode].self) else { return[] }
        
        return episodes
        
    }
    
    func downloadEpisode(episode: Episode) {
        
        guard let episodeStreamUrl = episode.streamUrl,
              let url = URL(string: episodeStreamUrl) else { return }
        
        downloadRequest = useCase.downloadEpisode(url: url,
                                progressHandler: { (progress) in
                                    
                                    print("Progress: \(progress)")
                                    
                                }) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let url):
                
                var mutableEpisode = episode
                mutableEpisode.fileUrl = url.absoluteString
                var episodes: [Episode] = self.getDownloads()
                episodes.insert(mutableEpisode, at: 0)
                
                self.userDefaults.store(episodes, key: .downloadEpisodeKey)
                
            case .failure:
                break
            }
            
        }
        
//        var episodes: [Episode] = getDownloads()
//        episodes.insert(episode, at: 0)
//
//        self.userDefaults.store(episodes, key: .downloadEpisodeKey)
        
    }
    
    func getDownloads() {
        
        self.downloads.accept(self.getDownloads())
        
    }
    
    func removeDownload(episode: Episode) {
        
        var episodes: [Episode] = getDownloads()
        
        if let index = episodes.firstIndex(where: { (ep) -> Bool in
            return ep.title == episode.title && ep.author == episode.author
        }) {
            
            episodes.remove(at: index)
            self.userDefaults.store(episodes, key: .downloadEpisodeKey)
        
        }
        
    }
    
    func getOutputs() -> DownloadViewModelOutputs {
        return self
    }
    
}
