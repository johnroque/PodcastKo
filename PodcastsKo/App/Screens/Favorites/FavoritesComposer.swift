//
//  FavoritesComposer.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit

final class FavoritesComposer {
    
    private init() {}
    
    static func composeWith() -> FavoritesViewController {
        let vc = FavoritesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        return vc
    }
    
}
