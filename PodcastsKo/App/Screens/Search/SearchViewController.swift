//
//  SearchViewController.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UITableViewController {
    
    // MARK: - Dependencies
    var viewModel: SearchViewViewModel?
    
    private var data: [Podcast] = []
    private let cellId = "cellId"
    
    // MARK: - Views
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        setupSearchController()
        setupBindings()
    }
    
    private func setupSearchController() {
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.rx.text.asDriver().drive(onNext: { [weak self] (text) in
            guard let self = self else { return }
            
            self.viewModel?.searchPodcastViewModel.searchPodcast(title: text ?? "")
        })
        .disposed(by: self.disposeBag)
        
    }
    
    private func setupBindings() {
        self.viewModel?
            .searchPodcastViewModel
            .getOutputs()
            .podcasts
            .asDriver()
            .drive(onNext: { [weak self] (data) in
                
                self?.data = data
                self?.tableView.reloadData()
                
            })
            .disposed(by: self.disposeBag)
    }
    
    private func registerCell() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let podcast = data[indexPath.row]
        cell.textLabel?.text = "\(podcast.artistName)\n\(podcast.trackName)"
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        
        return cell
    }
    
}
