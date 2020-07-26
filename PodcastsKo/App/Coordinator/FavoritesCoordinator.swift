//
//  FavoritesCoordinator.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit

class FavoritesCoordinator: CoordinatorType {
    
    var childCoordinators: [CoordinatorType] = []
    
    // MARK: - Navigation
    /// Root ViewController for FavoritesCoordinator flow
    lazy var navigation: UINavigationController = {
        let navigationVc = UINavigationController(rootViewController: favoritesVc)
        return navigationVc
    }()
    
    // MARK: - Screens
    lazy var favoritesVc: FavoritesViewController = {
        let vc = FavoritesComposer.composeWith()
        return vc
    }()
    
    /// Trigger to start FavoritesCoordinator Flow
    func start() {
        
    }
    
}
