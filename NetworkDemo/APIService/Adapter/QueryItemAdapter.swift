//
//  QueryItemAdapter.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/5.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

struct QueryItemAdapter: RequestAdapter {
    
    let parameters: [String: String]?
    
    func adapted(_ request: URLRequest) throws -> URLRequest {
        guard let parameters = parameters,
            let url = request.url else {
            return request
        }
        
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryItems
        
        var request = request
        request.url = urlComponents?.url
        return request
    }
}
