//
//  ParseResultMoldeDecision.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/4.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public struct DecodeDecision: HTTPDecision {
    
    let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

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
        
        do {
            let model = try decoder.decode(Req.Response.self, from: data)
            var request = request
            request.responseModel = model
            action(.next(request, data, response))
        } catch {
            action(.errored(HTTPError.Response.decode(error)))
        }
    }
}
