//
//  DownloadEpisodeUseCase.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public protocol DownloadEpisodeUseCase {
    typealias Completion = Result<URL, Error>
    
    func downloadEpisode(url: URL,
                         progressHandler: ((Double) -> Void)?,
                         completionHandler: @escaping (Completion) -> Void) -> CancellableTask
}
