//
//  HTTPClient.swift
//  PodcastsKo
//
//  Created by John Roque Jorillo on 7/27/20.
//  Copyright © 2020 JohnRoque Inc. All rights reserved.
//

import Foundation

protocol URLSessionRequest {
    var urlRequest: URLRequest { get }
}

protocol HttpClientTask {
    func cancel()
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    typealias DownloadResult = Swift.Result<(URL, HTTPURLResponse), Error>
    
    func get(request: URLSessionRequest, completionHandler: @escaping (HTTPClient.Result) -> Void) -> HttpClientTask
    func download(request: URLSessionRequest,
                  progressHandler: ((Double) -> Void)?,
                  completionHandler: @escaping (HTTPClient.DownloadResult) -> Void) -> HttpClientTask
}
