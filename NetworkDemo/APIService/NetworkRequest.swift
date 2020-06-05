//
//  NetworkRequest.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation
import Alamofire

public protocol NetworkRequest: URLRequestConvertible {
    
    /// 定義回傳的 Model
    associatedtype Response: Decodable
    
    var tag: String { get }
    
    var baseURL: URL { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var parameters: Parameters? { get }
    
    var adapters: [RequestAdapter] { get }
    
    var decisions: [NetworkDecision] { get }
    
    var responseModel: Response? { get set }
}

public extension NetworkRequest {
    
    // setup default value
    var tag: String { "Tag not set." }
    
    var baseURL: URL { URL(string: "https://postman-echo.com")! }
    
    // 可以改成常用的
    var method: HTTPMethod { .GET }
    
    var path: String { "" }
    
    var headers: [String: String]? {
        [
            "device": "iOS"
        ]
    }
    
    var parameters: Parameters? { nil }
    
    var adapters: [RequestAdapter] { defaultAdapters }
    
    var defaultAdapters: [RequestAdapter] {
        [
            MethodAdapter(method: method),
            HeaderAdapter(data: headers)
        ]
    }
       
    var decisions: [NetworkDecision] { defaultDecisions }
    
    var defaultDecisions: [NetworkDecision] {
        [
            LogDecision(),
            DecodeDecision(),
            StatusCodeDecision(),
            DoneDecision()
        ]
    }
    
    var responseModel: Response? {
        get { nil } set { }
    }
}

extension NetworkRequest {
    var url: URL { baseURL.appendingPathComponent(path) }
}

extension NetworkRequest {
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(path)
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest = try adapters.reduce(urlRequest, { try $1.adapted($0) })
        
        urlRequest.timeoutInterval = 30
        
        return urlRequest
    }
}
