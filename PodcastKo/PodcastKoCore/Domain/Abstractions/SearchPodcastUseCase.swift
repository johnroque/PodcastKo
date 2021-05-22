//
//  SearchPodcastUseCase.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public protocol SearchPodcastUseCase {
    typealias CompletionHandler = (_ result: Result<[Podcast], Error>) -> Void
    
    func searchPodcast(title: String,
                       completionHandler: @escaping CompletionHandler) -> CancellableTask
}
