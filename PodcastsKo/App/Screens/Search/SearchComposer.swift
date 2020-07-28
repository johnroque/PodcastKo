//
//  SearchComposer.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

final class SearchComposer {
    
    private init() {}
    
    static func composeWith() -> SearchViewController {
        
        // Setup Api
        let apiLogger = ApiLogger()
        let apiClient = URLSessionHttpClient(session: URLSession(configuration: .default), logger: apiLogger)
        let apiGateway = ApiPodcastGatewayImpl(client: apiClient)
        
        let searchPodCastVm = SearchPodcastViewModel(useCase: apiGateway)
        let searchViewVm = SearchViewViewModel(searchPodcastViewModel: searchPodCastVm)
        
        let vc = SearchViewController()
        vc.viewModel = searchViewVm
        return vc
    }
    
}
