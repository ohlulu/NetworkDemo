//
//  HTTPRequest.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation
import Alamofire

// 封裝請求
public protocol HTTPRequest: URLRequestConvertible {
    
    /// 宣告 generic for response model
    associatedtype Response: Decodable
    
    /// 辨識用（ex. [101] - 登入）
    var tag: String { get }
    
    var baseURL: URL { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var headers: [String: String]? { get }
    
    /// 仿 Moya 封裝 upload/download... request
    var task: Task { get }
    
    /// request adapter
    var adapters: [RequestAdapter] { get }
    
    var plugins: [HTTPPlugin] { get }
    
    /// response decision
    var decisions: [HTTPDecision] { get }
    
    /// 定義回傳的 Model
    var responseModel: Response? { get set }
}

public extension HTTPRequest {
    
    // setup default value
    var tag: String { "Tag not set." }
    
    var baseURL: URL { URL(string: "https://postman-echo.com")! }
    
    // 可以改成專案中常用的
    var method: HTTPMethod { .get }
    
    var path: String { "" }
    
    // 特定 API 才需要的 Header
    var headers: [String: String]? { nil }
    
    // 固定的Header
    var defaultHeaders: [String: String]? { nil }
    
    // 可以改成專案中常用的
    var task: Task { .normal }
    
    // 預設用 defaultAdapters
    var adapters: [RequestAdapter] { defaultAdapters }
    
    var defaultAdapters: [RequestAdapter] {
        [
            MethodAdapter(method: method),
            HeaderAdapter(default: defaultHeaders, data: headers),
            task
        ]
    }
    
    // 預設用 defaultDecisions
    var decisions: [HTTPDecision] { defaultDecisions }
    
    var defaultDecisions: [HTTPDecision] {
        [
            StatusCodeDecision(),
            DecodeDecision(),
            DoneDecision()
        ]
    }
    
    var plugins: [HTTPPlugin] { defaultPlugins }
    
    var defaultPlugins: [HTTPPlugin] {
        [
            LoggerPlugin()
        ]
    }
    
    var responseModel: Response? {
        get { nil } set { }
    }
}

extension HTTPRequest {
    
    var url: URL { baseURL.appendingPathComponent(path) }
}

extension HTTPRequest {
    
    public func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(path)
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest = try adapters.reduce(urlRequest, { try $1.adapted($0) })
        
        urlRequest.timeoutInterval = 30
        
        return urlRequest
    }
}
