//
//  FavoritesCoordinator.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit
import PodcastKoCore

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
        vc.coordinator = self
        return vc
    }()
    
    /// Trigger to start FavoritesCoordinator Flow
    func start() {
        
    }
    
}

extension FavoritesCoordinator: FavoritesViewControllerDelegate {
    
    func showEpisodes(_ vc: FavoritesViewController, podCast: Podcast) {
        
        let episodesVc = EpisodesComposer.composeWith(podCast: podCast)
        episodesVc.coordinator = self
        self.navigation.pushViewController(episodesVc, animated: true)
        
    }
    
}

extension FavoritesCoordinator: EpisodesViewControllerDelegate {
    
    func back(_ vc: EpisodesViewController) {
        self.navigation.popViewController(animated: true)
    }
    
}
