//
//  Task.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/6.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation

/// 可自行新增專案中用到的 Task 常用類型，並對應 alamofire 的 download/upload request
public enum Task {
    
    case normal
    
    case upload([MultipartColumn])
    
    case download(DownloadDestination)
}

extension Task: RequestAdapter {
    public func adapted(_ request: URLRequest) throws -> URLRequest {
        
        var request = request
        let contentField = "Content-Type"
        
        switch self {
        case .normal:
            request.addValue("application/json", forHTTPHeaderField: contentField)
        case .upload:
            request.addValue("multipart/form-data", forHTTPHeaderField: contentField)
        case .download:
            break
        }
        
        return request
    }
}
