//
//  AnyAdapter.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

struct AnyAdapter: RequestAdapter {
    let block: (URLRequest) throws -> URLRequest
    func adapted(_ request: URLRequest) throws -> URLRequest {
        return try block(request)
    }
}
