//
//  MethodAdapter.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public struct MethodAdapter: RequestAdapter {
    
    let method: HTTPMethod
    
    public func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.httpMethod = method.rawValue
        return request
    }
}
