//
//  GetEpisodesViewModel.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PodcastKoCore

protocol GetEpisodesViewModelInputs {
    func getEpisodes()
    func getOutputs() -> GetEpisodesViewModelOutputs
}

protocol GetEpisodesViewModelOutputs {
    var isProcessing: BehaviorRelay<Bool> { get }
    var error: BehaviorRelay<String?> { get }
    var episodes: BehaviorRelay<[Episode]> { get }
}

final class GetEpisodesViewModel: GetEpisodesViewModelInputs, GetEpisodesViewModelOutputs {
    
    private var useCase: GetEpisodesUseCase
    
    init(useCase: GetEpisodesUseCase) {
        self.useCase = useCase
    }
    
    let isProcessing: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let error: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let episodes: BehaviorRelay<[Episode]> = BehaviorRelay(value: [])
    
    func getEpisodes() {
        
        self.useCase.getEpisodes() {
            [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let episodes):
                self.episodes.accept(episodes)
            case .failure(let error):
                self.error.accept(error.localizedDescription)
            }
            
        }
        
    }
    
    func getOutputs() -> GetEpisodesViewModelOutputs {
        return self
    }
    
}
