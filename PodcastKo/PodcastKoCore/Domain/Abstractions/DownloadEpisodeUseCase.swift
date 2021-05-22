//
//  DownloadEpisodeUseCase.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

protocol DownloadEpisodeUseCase {
    typealias CompletionHandler = (_ result: Result<URL, Error>) -> Void
    
    func downloadEpisode(url: URL,
                         progressHandler: ((Double) -> Void)?,
                         completionHandler: @escaping CompletionHandler) -> CancellableTask
}
