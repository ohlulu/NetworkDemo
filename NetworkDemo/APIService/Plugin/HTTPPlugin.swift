//
//  HTTPPlugin.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public protocol HTTPPlugin {
    typealias ResultType = (Data?, URLResponse?, Error?)
    func willSend<Req: NetworkRequest>(_ request: Req, urlRequest: URLRequest)
    func didReceive<Req: NetworkRequest>(_ request: Req, result: ResultType)
}
