//
//  GetEpisodeUseCase.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public protocol GetEpisodesUseCase {
    typealias Result = Swift.Result<[Episode], Error>
    
    func getEpisodes(completion: @escaping (Result) -> Void)
}
