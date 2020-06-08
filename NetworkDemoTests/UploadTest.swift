//
//  UploadTest.swift
//  NetworkDemoTests
//
//  Created by Ohlulu on 2020/6/7.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import XCTest
@testable import NetworkDemo

struct UploadRequest: NetworkRequest {
    
    var baseURL: URL { URL(string: "https://api.imgur.com/3/upload")! }
    var method: HTTPMethod { .POST }
    var headers: [String : String]? {
        ["Authorization": "Client-ID 20817cd2e0e08b2"]
    }
    
    let image = UIImage(named: "image")!
    var task: Task {
        .upload([
            MultipartColumn(provider: "TEST", name: "title"),
            MultipartColumn(provider: .image(image), name: "image", fileName: "QQ.png", mimeType: "image/png")
        ])
    }

    var responseModel: ResponseModel?
}

struct ResponseModel: Decodable {
    let success: Bool
}

class UploadTest: XCTestCase {
    
    public var client: HTTPClient!
    
    override func setUp() {
        super.setUp()
        client = HTTPClient()
    }
    
    override func tearDown() {
        client = nil
        super.tearDown()
    }
    
    func testUpload() {
        let expectation = self.expectation(description: "test")
        let request = UploadRequest()
        client.send(request) { result in
            switch result {
            case .success(let data):
                print("✅", data)
                XCTAssertEqual(data.success, true)
            case .failure(let error):
                XCTFail("❌ 不應該出錯 -> \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
