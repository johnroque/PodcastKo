//
//  FavoritesViewController.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit

class FavoritesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let cellId = "cellId"
    private var data: [Podcast] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var viewModel: FavoritesViewViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let data = self.viewModel?.getFavoritePodcasts() {
            self.data = data
        }
        
        let window = UIWindow.key
        if let nav = window?.rootViewController as? UINavigationController,
            let mainTab = nav.viewControllers.first as? MainTabBarController {
                
            mainTab.viewControllers?[0].tabBarItem.badgeValue = nil
        
        }
    }
    
    private func configureCollection() {
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.register(FavoritePodcastCollectionViewCell.self, forCellWithReuseIdentifier: self.cellId)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleCollectionLongPress))
        collectionView.addGestureRecognizer(gesture)
        
    }
    
    @objc private func handleCollectionLongPress(gesture: UILongPressGestureRecognizer) {
        
        let location = gesture.location(in: collectionView)
        
        if let selectedIndex = collectionView.indexPathForItem(at: location) {
            self.remoteFavorite(index: selectedIndex)
        }
        
    }
    
    private func remoteFavorite(index: IndexPath) {
        
        let alertController = UIAlertController(title: "Remote Podcast?", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] (_) in
//            self?.viewModel.
            self?.data.remove(at: index.item)
//            self?.collectionView.deleteItems(at: [index])
            if let data = self?.data {
                self?.viewModel?.saveNewPodcasts(podcasts: data)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! FavoritePodcastCollectionViewCell
        
        cell.configure(podcast: self.data[indexPath.item])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        
        return CGSize(width: width, height: width + 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
