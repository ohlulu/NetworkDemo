//
//  HTTPPlugin.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public protocol HTTPPlugin: class {
    
    typealias RequestType<Req: HTTPRequest> = (Req, URLRequest?)
    typealias ResultType = (Data?, URLResponse?, Error?)
    
    func willSend<Req: HTTPRequest>(_ request: RequestType<Req>)
    func didReceive<Req: HTTPRequest>(_ request: RequestType<Req>, result: ResultType)
}
