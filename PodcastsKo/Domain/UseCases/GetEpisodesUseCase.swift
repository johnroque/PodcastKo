//
//  GetEpisodesUseCase.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/30/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

typealias GetEpisodesUseCaseCompletionHandler = (_ result: Result<[Episode], Error>) -> Void

protocol GetEpisodesUseCase {
    func getEpisodes(url: URL, completionHandler: @escaping GetEpisodesUseCaseCompletionHandler)
}
