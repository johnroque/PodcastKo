//
//  XCTestCase+MemoryLeakTrackingHelper.swift
//  PodcastKoCoreTests
//
//  Created by John Roque Jorillo on 5/25/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
