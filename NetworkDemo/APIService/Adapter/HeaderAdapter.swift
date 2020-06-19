//
//  HeaderAdapter.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public struct HeaderAdapter: RequestAdapter {

    let `default`: [String: String]?
    let data: [String: String]?
    
    public func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        
        if let `default` = `default` {

            `default`.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let data = data {
            
            data.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}
