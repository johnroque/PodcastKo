//
//  MainTabBarController.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    // MARK: - Player
    private var playerView: PodcastPlayerUIView? = nil
    
    private var maximizedTopAnchorConstraint: NSLayoutConstraint?
    private var minimizeTopAnchorConstraint: NSLayoutConstraint?
    private var playerBottomAnchorConstraint: NSLayoutConstraint?
    
    func showPlayer(episode: Episode?) {
        if playerView == nil {
            attachPlayer()
        }

        maximizePlayer(episode: episode)
    }
    
    private func attachPlayer() {
        
        self.playerView = PodcastPlayerUIView()
        guard let playerView = self.playerView else { return }
        
        view.insertSubview(playerView, belowSubview: tabBar)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizeTopAnchorConstraint = playerView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        maximizedTopAnchorConstraint?.isActive = true
        
        playerBottomAnchorConstraint = playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        NSLayoutConstraint.activate([
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerBottomAnchorConstraint!
        ])
        
    }
    
    func closePlayer() {
        playerView?.removeFromSuperview()
        playerView = nil
    }
    
    func maximizePlayer(episode: Episode?) {
        minimizeTopAnchorConstraint?.isActive = false
        maximizedTopAnchorConstraint?.isActive = true
        maximizedTopAnchorConstraint?.constant = 0
        playerBottomAnchorConstraint?.constant = 0
        
        if let episode = episode {
            self.playerView?.episode = episode
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
            self?.tabBar.isHidden = true
            self?.playerView?.configureMaximize()
            
        }, completion: nil)
    }
    
    func minimizePlayer() {
        maximizedTopAnchorConstraint?.isActive = false
        playerBottomAnchorConstraint?.constant = view.frame.height
        minimizeTopAnchorConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
            self?.tabBar.isHidden = false
            self?.playerView?.configureMinimize()
            
        }, completion: nil)
        
    }

}
