//
//  Cancelable.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/7.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation
import Alamofire

public protocol Cancellable {
    func cancel()
}

public final class CancelToken: Cancellable {
    
    
    let cancelAction: () -> Void
    let request: Request?
    
    init(request: Request? = nil) {
        self.request = request
        self.cancelAction = {
            request?.cancel()
        }
    }
    
    public func cancel() {
        cancelAction()
    }
}
