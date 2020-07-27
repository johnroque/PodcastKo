//
//  HTTPURLResponse+StatusCode.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/28/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    var isOK: Bool {
        let successRange = 200...299
        return successRange.contains(self.statusCode)
    }
}
