//
//  JSONAdapter.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/5.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public typealias HTTPBodyConvertible = Encodable & JSONConvertible

public protocol JSONConvertible {
    func asJSONData(encoder: JSONEncoder?) throws -> Data
}

public extension JSONConvertible where Self: Encodable {
    func asJSONData(encoder: JSONEncoder? = nil) throws -> Data {
        let _encoder: JSONEncoder
        if let encoder = encoder {
            _encoder = encoder
        } else {
            _encoder = JSONEncoder()
        }
        
        return try _encoder.encode(self)
    }
}

extension Dictionary: JSONConvertible where Key == String {
    public func asJSONData(encoder: JSONEncoder? = nil) throws -> Data {
        try JSONSerialization.data(withJSONObject: self, options: [])
    }
}

public struct JSONRequestAdapter: RequestAdapter {
    
    private let data: HTTPBodyConvertible?
    private let encoder: JSONEncoder
    
    init(data: HTTPBodyConvertible? = nil, encoder: JSONEncoder = JSONEncoder()) {
        
        self.data = data
        self.encoder = encoder
    }
    
    public func adapted(_ request: URLRequest) throws -> URLRequest {
        
        let body = try data?.asJSONData(encoder: encoder)
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }
}
