//
//  HTTPURLResponse+StatusCode.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public extension HTTPURLResponse {
    var isOK: Bool {
        let successRange = 200...299
        return successRange.contains(self.statusCode)
    }
}
