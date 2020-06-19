//
//  AlamofireInterface.swift
//  FlickrDemo
//
//  Created by Ohlulu on 2020/6/16.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation
import Alamofire

public typealias DownloadDestination = DownloadRequest.Destination

public typealias RequestableCompletion = (HTTPURLResponse?, URLRequest?, Data?, Swift.Error?) -> Void

/**
 統一 DataRequest / UploadRequest / DownloadRequest respons 介面
 Note. UploadRequest 繼承自 DataRequest，所以不用實作
 */
protocol Requestable {
    func response(completionHandler: @escaping RequestableCompletion) -> Self
}

extension DataRequest: Requestable {
    func response(completionHandler: @escaping RequestableCompletion) -> Self {
        response { handler  in
            completionHandler(handler.response, handler.request, handler.data, handler.error)
        }
    }
}

extension DownloadRequest: Requestable {
    internal func response(completionHandler: @escaping RequestableCompletion) -> Self {
        response { handler  in
            
            // TODO: not good
            guard let path = handler.fileURL?.path, let data = "{\"fileURL\": \"\(path)\"}".data(using: .utf8) else {
                completionHandler(handler.response, handler.request, nil, handler.error)
                return
            }
            completionHandler(handler.response, handler.request, data, handler.error)
        }
    }
}


