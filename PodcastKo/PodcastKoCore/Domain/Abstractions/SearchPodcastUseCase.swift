//
//  SearchPodcastUseCase.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public protocol SearchPodcastUseCase {
    typealias Result = Swift.Result<[Podcast], Error>
    
    func searchPodcast(title: String,
                       completion: @escaping (Result) -> Void) -> CancellableTask
}
