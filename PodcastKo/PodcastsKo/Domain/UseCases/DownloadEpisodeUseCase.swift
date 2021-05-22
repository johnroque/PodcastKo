//
//  DownloadEpisodeUseCase.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 12/27/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

typealias DownloadEpisodeUseCaseCompletionHandler = (_ result: Result<URL, Error>) -> Void

protocol DownloadEpisodeUseCase {
    func downloadEpisode(url: URL,
                         progressHandler: ((Double) -> Void)?,
                         completionHandler: @escaping DownloadEpisodeUseCaseCompletionHandler) -> HttpClientTask
}
