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
    
    /// Main navigation controller of iOS App
    lazy var navigation: UINavigationController = {
        let navigationVc = UINavigationController(rootViewController: UIViewController())
        return navigationVc
    }()
    
    /// Trigger start for main coordinator
    func start() {
        
    }
    
}
