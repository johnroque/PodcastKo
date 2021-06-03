//
//  SearchComposer.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation
import PodcastKoCore

final class SearchComposer {
    
    private init() {}
    
    static func composeWith() -> SearchViewController {
        
        // Setup Api
        let apiClient = URLSessionHTTPClient(session: URLSession(configuration: .default))
        let apiGateway = SearchPodcastAPIGateway(url: URL(string: "https://itunes.apple.com/search")!, client: apiClient)
        
        let searchPodCastVm = SearchPodcastViewModel(useCase: apiGateway)
        let searchViewVm = SearchViewViewModel(searchPodcastViewModel: searchPodCastVm)
        
        let vc = SearchViewController()
        vc.viewModel = searchViewVm
        return vc
    }
    
}
