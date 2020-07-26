//
//  SearchCoordinator.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit

class SearchCoordinator: CoordinatorType {
    
    var childCoordinators: [CoordinatorType] = []
    
    // MARK: - Navigation
    /// Root ViewController for SearchCoordinator flow
    lazy var navigation: UINavigationController = {
        let navigationVc = UINavigationController(rootViewController: searchVc)
        return navigationVc
    }()
    
    // MARK: - Screens
    lazy var searchVc: SearchViewController = {
        let vc = SearchComposer.composeWith()
        return vc
    }()
    
    /// Trigger to start SearchCoordinator Flow
    func start() {
        
    }
    
}
