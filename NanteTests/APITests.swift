//
//  APITests.swift
//  NanteTests
//
//  Created by 谷内洋介 on 2023/09/03.
//

import XCTest
@testable import Nante

class APITests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: config)
        // ここで、fetch関数がこのmockSessionを使用するように設定します（fetch関数がURLSessionを引数として取れるように修正が必要かもしれません）
    }

    func testFetchAPI() {
        let expectation = self.expectation(description: "API fetch expectation")

        let sampleURL = "https://sampleAPI.com/data"
        let mockResponse = [
            "key": "value"
        ]

        let responseData = try! JSONSerialization.data(withJSONObject: mockResponse, options: .prettyPrinted)
        MockURLProtocol.stubResponses[URL(string: sampleURL)!] = (responseData, HTTPURLResponse(url: URL(string: sampleURL)!, statusCode: 200, httpVersion: nil, headerFields: nil), nil)

        fetch(apiURL: sampleURL, apiKey: nil, requestBody: ["requestKey": "requestValue"]) { (result: [String: String]?, error) in
            XCTAssertNotNil(result)
            XCTAssertEqual(result?["key"], "value")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}

