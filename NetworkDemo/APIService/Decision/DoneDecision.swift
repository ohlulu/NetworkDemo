//
//  DoneDecision.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/5.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public struct DoneDecision: HTTPDecision {

    public func shouldApply<Req: HTTPRequest>(
        request: Req,
        data: Data,
        response: HTTPURLResponse
    ) -> Bool {
        
        true
    }
    
    public func apply<Req: HTTPRequest>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        action: @escaping (DecisionAction<Req>) -> Void
    ) {
        
        guard let model = request.responseModel else {
            action(.errored(HTTPError.Decision.somethingErrorAtDecodeDecision))
            return
        }
        action(.done(model))
    }
}
