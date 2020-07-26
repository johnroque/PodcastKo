//
//  SearchViewController.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    private var data = [("Lets Build that App", "Brian Voong"), ("Some Podcase", "Some Author")]
    private let cellId = "cellId"
    
    // MARK: - Views
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        setupSearchController()
    }
    
    private func setupSearchController() {
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
        
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
        cell.textLabel?.text = "\(podcast.0)\n\(podcast.1)"
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        
        return cell
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
}
