//
//  EpisodesViewController.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol EpisodesViewControllerDelegate {
    func back(_ vc: EpisodesViewController)
}

class EpisodesViewController: UITableViewController {
    
    // MARK: - dependencies
    var podCast: Podcast?
    var coordinator: EpisodesViewControllerDelegate?
    var viewModel: EpisodesViewViewModel?
    
    // MARK: - Views
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        button.tintColor = .purple
        return button
    }()
    
    private lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: nil)
        button.tintColor = .purple
        return button
    }()
    
    // MARK: - Private properties
    private var data = [Episode]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let cellId = "cellId"
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureTableView()
        setupBindings()
        getEpisodes()
    }
    
    private func getEpisodes() {
        
        self.viewModel?.getEpisodesViewModel.getEpisodes(urlString: self.podCast?.feedUrl)
        
    }
    
    private func configureNavigation() {
        
        self.title = podCast?.trackName
        self.navigationItem.leftBarButtonItem = backButton
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                self.coordinator?.back(self)
            })
            .disposed(by: self.disposeBag)
        
        self.navigationItem.rightBarButtonItem = favoriteButton
        
        favoriteButton.rx.tap
            .asDriver()
            .drive(onNext: { [unowned self] in
                guard let podcast = self.podCast else { return }
                
                self.viewModel?.saveFavoritePodcast(podcast: podcast)
            })
            .disposed(by: self.disposeBag)
        
    }
    
    private func configureTableView() {
        
        tableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: self.cellId)
        tableView.separatorStyle = .none
        
    }
    
    private func setupBindings() {
        
        self.viewModel?
            .getEpisodesViewModel
            .getOutputs()
            .episodes
            .asDriver()
            .drive(onNext: { [weak self] (data) in
                self?.data = data
            })
            .disposed(by: self.disposeBag)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! EpisodeTableViewCell
        
        let episode = self.data[indexPath.row]
        cell.configure(episode: episode)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: Deprecated keywindow for ios13
//        let window = UIApplication.shared.keyWindow
//     
//        let view = PodcastPlayerUIView(frame: self.view.frame)
//        view.episode = self.data[indexPath.row]
//        
//        window?.addSubview(view)
        
        let window = UIWindow.key
        if let nav = window?.rootViewController as? UINavigationController,
            let mainTab = nav.viewControllers.first as? MainTabBarController {
            
            mainTab.showPlayer(episode: self.data[indexPath.row], episodes: self.data)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.data.isEmpty ? 200 : 0
    }
    
}
