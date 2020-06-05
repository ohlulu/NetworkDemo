//
//  ParameterConvertible.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

extension Parameters {
    
    func convertToQueryDictionary() -> [String: String]? {
        
        return self as? [String: String]
    }
}

//
//public protocol ParameterConvertible {
//
//    func convertToParameter() -> [String: Any]?
////    func convertToQueryDictionary() -> [String: String]?
//}
//
//public extension ParameterConvertible where Self: Encodable {
//
//    func convertToParameter() -> [String: Any]? {
//        do {
//            let data = try JSONEncoder().encode(self)
//            return try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]) as? [String: Any]
//        } catch {
//            fatalError("\(error)")
//        }
//    }
//
//    func convertToQueryDictionary() -> [String: String]? {
//        return nil
//    }
//}
//
//extension Dictionary:  where Key == String {
//    public func convertToQueryDictionary() -> [String : String]? {
//        <#code#>
//    }
//
//
//    public func convertToParameter() -> [String: Any]?{
//        return self
//    }
//}
//
//extension Dictionary where Key == String, Value == String {
//
//    public func convertToQueryDictionary() -> [String: String]? {
//        return self
//    }
//}
//
//
