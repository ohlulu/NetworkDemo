//
//  HeaderAdapter.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public struct HeaderAdapter: RequestAdapter {
    
    let data: [String: String]?
    
    public func adapted(_ request: URLRequest) throws -> URLRequest {
        guard let data = data else { return request }
        
        var request = request
        data.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
