//
//  LogerPulgin.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/17.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

class LoggerPlugin: HTTPPlugin {
    
    var startTime: Date?
    var endTime: Date?
    
    fileprivate static let formatter = DateFormatter()
    
    func willSend<Req>(_ request: (Req, URLRequest?)) where Req : HTTPRequest {
        startTime = Date()
    }
    
    func didReceive<Req>(_ request: (Req, URLRequest?), result: ResultType) where Req : HTTPRequest {
        endTime = Date()
        
        let costTime: TimeInterval
        if let startTime = startTime, let endTime = endTime {
            costTime = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
        } else {
            costTime = 0
        }
        
        let log = """
        ----------------------------------------------------------------------
        \(request.0.tag)
        URL -> \(request.0.urlRequest?.url?.absoluteString ?? "nil")
        request time -> \(startTime?.toString() ?? "nil")
        cost time -> \(String(format: "%.3f", costTime)) s
        headers -> \(request.1?.allHTTPHeaderFields ?? [:])
        Request Body -> \(jsonString(data: request.1?.httpBody))
        Response Body -> \(jsonString(data: result.0))
        ----------------------------------------------------------------------
        """
        
        print(log)
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
        let formatter = LoggerPlugin.formatter
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
