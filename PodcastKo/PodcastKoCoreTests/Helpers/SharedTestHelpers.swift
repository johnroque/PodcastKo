//
//  SharedTestHelpers.swift
//  PodcastKoCoreTests
//
//  Created by John Roque Jorillo on 5/25/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0, userInfo: nil)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
