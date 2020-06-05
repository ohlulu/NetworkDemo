//
//  HTTPError.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    
    enum Response: Error {
        case nilData
        case nilResponse
        case statusCode(code: Int, body: Data)
        case decode(Error)
    }
    
    enum AF: Error {
        case error(AFError)
    }
    
    enum Decision: Error {
        case decisionsIsEmpty
        case somethingErrorAtDecodeDecision
    }
}