//
//  DownloadsCoordinator.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit

class DownloadsCoordinator: CoordinatorType {
    
    var childCoordinators: [CoordinatorType] = []
    
    // MARK: - Navigation
    /// Root ViewController for DownloadsCoordinator flow
    lazy var navigation: UINavigationController = {
        let navigationVc = UINavigationController(rootViewController: downloadsVc)
        return navigationVc
    }()
    
    // MARK: - Screens
    lazy var downloadsVc: DownloadsViewController = {
        let vc = DownloadsComposer.composeWith()
        return vc
    }()
    
    /// Trigger to start DownloadsCoordinator Flow
    func start() {
        
    }
    
}
