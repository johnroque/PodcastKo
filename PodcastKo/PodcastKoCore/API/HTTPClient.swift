//
//  HTTPClient.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
//    typealias DownloadResult = Swift.Result<(URL, HTTPURLResponse), Error>
    
    @discardableResult
    func get(request: URLRequest, completionHandler: @escaping (Result) -> Void) -> HTTPClientTask
//    
//    @discardableResult
//    func download(request: URLRequest,
//                  progressHandler: ((Double) -> Void)?,
//                  completionHandler: @escaping (DownloadResult) -> Void) -> HttpClientTask
}
