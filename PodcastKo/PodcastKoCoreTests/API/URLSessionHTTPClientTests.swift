//
//  URLSessionHTTPClientTests.swift
//  PodcastKoCoreTests
//
//  Created by John Roque Jorillo on 5/23/21.
//  Copyright © 2021 JohnRoque Inc. All rights reserved.
//

import XCTest
import PodcastKoCore

class URLSessionHTTPClientTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let request = makeURLRequest(url: anyURL(), httpMethod: .GET)
        let exp = expectation(description: "Wait for completion")
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, request.url)
            XCTAssertEqual(request.httpMethod, request.httpMethod)
            exp.fulfill()
        }
        
        makeSUT().get(request: request) { _ in }
        
        wait(for: [exp], timeout: 2.0)
    }
    
    func test_cancelGetFromURLTask_cancelsURLRequest() {
        let request = makeURLRequest(url: anyURL(), httpMethod: .GET)
        let exp = expectation(description: "Wait for completion")
        
        let task = makeSUT().get(request: request) { result in
            switch result {
            case let .failure(error as NSError) where error.code == URLError.cancelled.rawValue:
                break
            default:
                XCTFail("Expected cancelled result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        task.cancel()
        wait(for: [exp], timeout: 2.0)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError()
        let receivedError = resultErrorFor((data: nil, response: nil, error: requestError))! as NSError
        
        XCTAssertEqual(receivedError.code, requestError.code)
        XCTAssertEqual(receivedError.domain, requestError.domain)
    }
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(resultErrorFor((data: nil, response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nil, error: nil)))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nil, error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: nil, response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: anyHTTPURLResponse(), error: anyNSError())))
        XCTAssertNotNil(resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: nil)))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let requestData = anyData()
        let requestResponse = anyHTTPURLResponse()
        
        let values = resultValuesFor((data: requestData, response: requestResponse, error: nil))
        
        XCTAssertEqual(values?.data, requestData)
        XCTAssertEqual(values?.response.url, requestResponse.url)
        XCTAssertEqual(values?.response.statusCode, requestResponse.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let requestResponse = anyHTTPURLResponse()
        let emptyData = Data()
        
        let values = resultValuesFor((data: nil, response: requestResponse, error: nil))
        
        XCTAssertEqual(values?.data, emptyData)
        XCTAssertEqual(values?.response.url, requestResponse.url)
        XCTAssertEqual(values?.response.statusCode, requestResponse.statusCode)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        return sut
    }
    
    private func resultValuesFor(_ values: (data: Data?, response: URLResponse?, error: Error?), file: StaticString = #file, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = resultFor(values, file: file, line: line)
        
        var receivedValues: (data: Data, response: HTTPURLResponse)?
        switch result {
        case let .success((data, response)):
            receivedValues = (data, response)
        default:
            XCTFail("Expected success got \(result) instead", file: file, line: line)
        }
        
        return receivedValues
    }
    
    private func resultErrorFor(_ values: (data: Data?, response: URLResponse?, error: Error?)? = nil, taskHandler: (HTTPClientTask) -> Void = { _ in }, file: StaticString = #file, line: UInt = #line) -> Error? {
        let result = resultFor(values, taskHandler: taskHandler, file: file, line: line)
        
        var receivedError: Error?
        switch result {
        case let .failure(error):
            receivedError = error
        default:
            XCTFail("Expected failure got \(result) instead", file: file, line: line)
        }
        
        return receivedError
    }
    
    private func resultFor(_ values: (data: Data?, response: URLResponse?, error: Error?)?, taskHandler: (HTTPClientTask) -> Void = { _ in },  file: StaticString = #file, line: UInt = #line) -> HTTPClient.Result {
        
        values.map { URLProtocolStub.stub(data: $0, response: $1, error: $2) }
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        let request = makeURLRequest(url: anyURL(), httpMethod: .GET)
        
        var receivedResult: HTTPClient.Result!
        taskHandler(sut.get(request: request) { result in
            receivedResult = result
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
    
    private func makeURLRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        return urlRequest
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0, userInfo: nil)
    }
}
