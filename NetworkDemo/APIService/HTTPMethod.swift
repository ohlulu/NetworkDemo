//
//  HTTPMethod.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/4.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

// 自訂 HTTPMethod 將來不論用哪套網路套件，或者自幹，皆可通
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

