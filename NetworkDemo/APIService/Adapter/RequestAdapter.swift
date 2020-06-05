//
//  RequestAdapter.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public protocol RequestAdapter {
    func adapted(_ request: URLRequest) throws -> URLRequest
}
