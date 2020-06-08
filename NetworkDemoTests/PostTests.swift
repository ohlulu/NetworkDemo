//
//  PostTests.swift
//  NetworkDemoTests
//
//  Created by Ohlulu on 2020/6/5.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import XCTest
@testable import NetworkDemo

struct PostWithJsonRequest: NetworkRequest {
    
    var path: String { "post" }
    var method: HTTPMethod = .post 
    let data: HTTPBodyConvertible
    
    var adapters: [RequestAdapter] {
        defaultAdapters + [
            JSONRequestAdapter(data: data)
        ]
    }
    var responseModel: PostJSONResponseModel?
    
    init(data: HTTPBodyConvertible) {
        self.data = data
    }
}

struct PostJsonRequestModel: HTTPBodyConvertible {
    
    let foo1 = "foo1"
    let foo2 = "中文呢"
}

struct PostJSONResponseModel: Decodable {
    struct Headers: Codable {
        let contentType: String
        private enum CodingKeys: String, CodingKey {
            case contentType = "content-type"
        }
    }
    let headers: Headers
    struct Json: Codable {
        let foo1: String
        let foo2: String
    }
    let json: Json
    let url: URL

}


class PostTests: XCTestCase {
    
    public var client: HTTPClient!
    
    override func setUp() {
        super.setUp()
        client = HTTPClient()
    }
    
    override func tearDown() {
        client = nil
        super.tearDown()
    }

    func testPostWithDic() {
        let request = PostWithJsonRequest(data: [
            "foo1": "foo1",
            "foo2": "中文呢"
        ])
        let expectation = self.expectation(description: "testPostWithDic")
        client.send(request) { result in
            switch result {
            case .success(let data):
                print("✅", data)
                XCTAssertEqual(data.json.foo1, "foo1")
                XCTAssertEqual(data.json.foo2, "中文呢")
                XCTAssertEqual(data.headers.contentType, "application/json")
            case .failure(let error):
                XCTFail("❌ 不應該出錯 -> \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testPostWithEncodable() {
        let request = PostWithJsonRequest(data: PostJsonRequestModel())
        
        let expectation = self.expectation(description: "testPostWithEncodable")
        client.send(request) { result in
            switch result {
            case .success(let data):
                print("✅", data)
                XCTAssertEqual(data.json.foo1, "foo1")
                XCTAssertEqual(data.json.foo2, "中文呢")
                XCTAssertEqual(data.headers.contentType, "application/json")
            case .failure(let error):
                XCTFail("❌ 不應該出錯 -> \(error)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
}

