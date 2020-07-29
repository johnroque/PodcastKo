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
    
    // MARK: - Views
    let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
        return button
    }()
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
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
        
    }

}
