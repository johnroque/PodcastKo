//
//  SearchPodcastUseCase.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/28/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

typealias SearchPodcaseUseCaseCompletionHandler = (_ result: Result<[Podcast], Error>) -> Void

protocol SearchPodcastUseCase {
    func searchPodcast(title: String,
                       completionHandler: @escaping SearchPodcaseUseCaseCompletionHandler) -> HttpClientTask
}
