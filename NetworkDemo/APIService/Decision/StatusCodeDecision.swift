//
//  StatusCodeDecision.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public struct StatusCodeDecision: HTTPDecision {

    public func shouldApply<Req: HTTPRequest>(
        request: Req,
        data: Data,
        response: HTTPURLResponse
    ) -> Bool {
        
        !(200..<300).contains(response.statusCode)
    }
    
    public func apply<Req: HTTPRequest>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        action: @escaping (DecisionAction<Req>) -> Void
    ) {
        
        action(.errored(HTTPError.Response.statusCode(code: response.statusCode, body: data)))
    }
}
