//
//  NetworkDemoTests.swift
//  NetworkDemoTests
//
//  Created by Ohlulu on 2020/6/4.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import XCTest
@testable import NetworkDemo

struct GetRequest: HTTPRequest {
    
    var method: HTTPMethod = .get
    var path: String = "get"
    var parameters: [String: String] = [
        "foo1": "foo1",
        "foo2": "測試中文"
    ]
    
    var adapters: [RequestAdapter] {
        defaultAdapters + [
            QueryItemAdapter(parameters: parameters)
        ]
    }
    
    var responseModel: GetMethodRespons?
}

struct GetMethodRespons: Codable {
    
    struct Args: Codable {
        let foo1: String
        let foo2: String
    }
    let args: Args
}


class NetworkDemoTests: XCTestCase {
    
    public var client: HTTPClient!
    
    override func setUp() {
        super.setUp()
        client = HTTPClient()
    }
    
    override func tearDown() {
        client = nil
        super.tearDown()
    }

    func testGet() {
        let request = GetRequest()
        let expectation = self.expectation(description: "GetRequest")
        client.send(request) { result in
            switch result {
            case .success(let data):
                print("✅", data)
                XCTAssertEqual(data.args.foo1, "foo1")
                XCTAssertEqual(data.args.foo2, "測試中文")
            case .failure(let error):
                XCTFail("❌ 不應該出錯 -> \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

}
