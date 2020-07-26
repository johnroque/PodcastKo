//
//  MainCoordinator.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit

protocol MainCoordinatorType {
    
    var navigation: UINavigationController { get set }
    
}

class MainCoordinator: CoordinatorType, MainCoordinatorType {
    
    var childCoordinators: [CoordinatorType] = []
    
    // MARK: - Navigation
    /// Main navigation controller of iOS App
    lazy var navigation: UINavigationController = {
        let navigationVc = UINavigationController(rootViewController: mainTabVc)
        navigationVc.isNavigationBarHidden = true
        return navigationVc
    }()
    
    // MARK: - Screens
    private lazy var mainTabVc: MainTabBarController = {
        let vc = MainTabBarComposer.composeWith()
        vc.tabBar.tintColor = .purple
        return vc
    }()
    
    /// Trigger start for MainCoordinator flow
    func start() {
        
        let favoritesCoordinator = FavoritesCoordinator()
        self.configure(for: favoritesCoordinator.navigation,
                       root: favoritesCoordinator.favoritesVc,
                       title: "Favorites", image: #imageLiteral(resourceName: "favorites"))
        self.childCoordinators.append(favoritesCoordinator)
        
        let searchCoordinator = SearchCoordinator()
        self.configure(for: searchCoordinator.navigation,
                       root: searchCoordinator.searchVc,
                       title: "Search", image: #imageLiteral(resourceName: "search"))
        self.childCoordinators.append(searchCoordinator)
        
        let downloadsCoordinator = DownloadsCoordinator()
        self.configure(for: downloadsCoordinator.navigation,
                       root: downloadsCoordinator.downloadsVc,
                       title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        self.childCoordinators.append(downloadsCoordinator)
        
        mainTabVc.viewControllers = [
            favoritesCoordinator.navigation,
            searchCoordinator.navigation,
            downloadsCoordinator.navigation
        ]
        
    }
    
    /// Helper function configuring navigtion
    /// - Parameters:
    ///   - controller: Usually a navigation controller
    ///   - root: The root viewController of navigation
    ///   - title: Title of the navigation
    ///   - image: Image icon for navigation
    private func configure(for controller: UINavigationController, root: UIViewController, title: String, image: UIImage) {
        controller.tabBarItem.title = title
        controller.tabBarItem.image = image
        controller.navigationBar.prefersLargeTitles = true
        root.navigationItem.title = title
    }
    
}
