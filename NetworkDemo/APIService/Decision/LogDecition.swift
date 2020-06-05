//
//  LogDecition.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/5.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

public struct LogDecision: NetworkDecision {
    
    
    var startTime: Date?
    var endTime: Date?
    
    fileprivate static let formatter = DateFormatter()
    
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
        
        let costTime: TimeInterval
        if let startTime = startTime, let endTime = endTime {
            costTime = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
        } else {
            costTime = 0
        }

        let log = """
        ----------------------------------------------------------------------
        \(request.tag)
        path -> \(request.urlRequest?.url?.absoluteString ?? "nil")
        request time -> \(startTime?.toString() ?? "nil")
        cost time -> \(String(format: "%.3f", costTime)) s
        Request Body -> \(jsonString(data: request.urlRequest?.httpBody))
        Response Body -> \(jsonString(data: data))
        ----------------------------------------------------------------------
        """
        
        print(log)
        action(.next(request, data, response))
    }
    
    private func jsonString(data: Data?) -> String {
        guard let data = data,
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
            let json = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted),
            let string = String(data: json, encoding: .utf8) else {
                return "nil"
        }
        return string.replacingOccurrences(of: "\\", with: "")
    }
}



private extension Date {
    func toString() -> String {
        let formatter = LogDecision.formatter
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
