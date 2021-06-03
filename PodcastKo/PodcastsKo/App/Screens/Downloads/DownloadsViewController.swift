//
//  DownloadsViewController.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/26/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PodcastKoCore

class DownloadsViewController: UITableViewController {

    private let cellId = "cellId"
    
    var viewModel: DownloadsViewViewModel?
    private var data: [Episode] = []
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewModel?.downloadViewModel.getDownloads()
    }

}

extension DownloadsViewController {
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        
        tableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
}

extension DownloadsViewController {
    
    private func bindViewModel() {
        
        let output = self.viewModel?.downloadViewModel.getOutputs()
        
        output?.downloads
            .asDriver()
            .drive(onNext: { [unowned self] (data) in
                self.data = data
                self.tableView.reloadData()
            })
            .disposed(by: self.disposeBag)
        
    }
    
}

extension DownloadsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeTableViewCell
    
        let data = self.data[indexPath.row]
        cell.configure(episode: data)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
 
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            tableView.dataSource?.tableView?(tableView, commit: .delete, forRowAt: indexPath)
            completion(true)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let episode = self.data[indexPath.row]
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.viewModel?.downloadViewModel.removeDownload(episode: episode)
         }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let window = UIWindow.key
        if let nav = window?.rootViewController as? UINavigationController,
            let mainTab = nav.viewControllers.first as? MainTabBarController {

            mainTab.showPlayer(episode: self.data[indexPath.row], episodes: self.data)

        }
    }
    
}
