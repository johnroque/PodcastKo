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

protocol SearchViewControllerDelegate {
    func showEpisodes(_ vc: SearchViewController, podCast: Podcast)
}

class SearchViewController: UITableViewController {
    
    // MARK: - Dependencies
    var viewModel: SearchViewViewModel?
    var coordinator: SearchViewControllerDelegate?
    
    private var data: [Podcast] = []
    private let cellId = "cellId"
    
    // MARK: - Views
    private let searchController = UISearchController(searchResultsController: nil)
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        registerCell()
        setupSearchController()
        setupBindings()
    }
    
    private func configureTableView() {
        self.tableView.separatorStyle = .none
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
        tableView.register(SearchPodCastTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.data.count > 0 ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchPodCastTableViewCell
        
        let podcast = data[indexPath.row]
        
        cell.configure(podcast: podcast)
        
//        cell.textLabel?.text = "\(podcast.artistName ?? "")\n\(podcast.trackName ?? "")"
//        cell.textLabel?.numberOfLines = 0
//        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let podcast = data[indexPath.row]
        self.coordinator?.showEpisodes(self, podCast: podcast)
        
    }
    
}
