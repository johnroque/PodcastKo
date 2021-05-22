//
//  HTTPClient.swift
//  PodcastKoCore
//
//  Created by John Roque Jorillo on 5/22/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import Foundation

public protocol URLSessionRequest {
    var urlRequest: URLRequest { get }
}

public protocol HttpClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    typealias DownloadResult = Swift.Result<(URL, HTTPURLResponse), Error>
    
    @discardableResult
    func get(request: URLSessionRequest, completionHandler: @escaping (Result) -> Void) -> HttpClientTask
    
    @discardableResult
    func download(request: URLSessionRequest,
                  progressHandler: ((Double) -> Void)?,
                  completionHandler: @escaping (DownloadResult) -> Void) -> HttpClientTask
}
