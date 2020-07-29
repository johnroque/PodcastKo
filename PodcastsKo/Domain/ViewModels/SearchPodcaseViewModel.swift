//
//  SearchPodcaseViewModel.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/28/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchPodcastViewModelInputs {
    func searchPodcast(title: String)
    func cancelSearch()
    func getOutputs() -> SearchPodcastViewModelOutputs
}

protocol SearchPodcastViewModelOutputs {
    var isProcessing: BehaviorRelay<Bool> { get }
    var error: BehaviorRelay<String?> { get }
    var podcasts: BehaviorRelay<[Podcast]> { get }
}

final class SearchPodcastViewModel: SearchPodcastViewModelInputs, SearchPodcastViewModelOutputs {
    
    private let useCase: SearchPodcastUseCase
    private var searchRequest: HttpClientTask?
    
    init(useCase: SearchPodcastUseCase) {
        self.useCase = useCase
    }
    
    let isProcessing: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let error: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let podcasts: BehaviorRelay<[Podcast]> = BehaviorRelay(value: [])
    
    func searchPodcast(title: String) {
        
        self.searchRequest?.cancel()
        
        self.searchRequest = self.useCase.searchPodcast(title: title) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let podcasts):
                self.podcasts.accept(podcasts)
            case .failure(let error):
                self.error.accept(error.localizedDescription)
            }
            
        }
    }
    
    func cancelSearch() {
        self.searchRequest?.cancel()
        self.searchRequest = nil
    }
    
    func getOutputs() -> SearchPodcastViewModelOutputs {
        return self
    }
    
}
