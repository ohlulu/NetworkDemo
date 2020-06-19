//
//  HTTPDecision.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public enum DecisionAction<Req: HTTPRequest> {
    case next(Req, Data, HTTPURLResponse)
    case restart([HTTPDecision])
    case errored(Error)
    case done(Req.Response)
}


public protocol HTTPDecision {
    
    func shouldApply<Req: HTTPRequest>(
        request: Req,
        data: Data,
        response: HTTPURLResponse
    ) -> Bool
    
    func apply<Req: HTTPRequest>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        action: @escaping (DecisionAction<Req>) -> Void
    )
}
