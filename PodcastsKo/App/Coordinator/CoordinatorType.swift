//
//  CoordinatorType.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

protocol CoordinatorType: AnyObject {

    var childCoordinators: [CoordinatorType] { get set }
    func start()

}

extension CoordinatorType {

    func add(_ childCoordinator: CoordinatorType) {
        childCoordinators.append(childCoordinator)
    }

    func remove(_ childCoordinator: CoordinatorType) {
        childCoordinators.removeAll(where: { $0 === childCoordinator })
    }

}
