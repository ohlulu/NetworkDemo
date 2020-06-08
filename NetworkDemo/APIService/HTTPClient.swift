//
//  HTTPClient.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/3.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import Foundation
import Alamofire

public struct HTTPClient {
    
    private let session: Alamofire.Session
    
    public init(session: Alamofire.Session = .default) {
        self.session = session
    }
    
    @discardableResult
    func send<Req: HTTPRequest>(
        _ request: Req,
        decisions: [NetworkDecision]? = nil,
        plugins: [HTTPPlugin] = [],
        progress: @escaping ((Progress) -> Void) = { _ in },
        handler: @escaping (Result<Req.Response, Error>) -> Void
    ) -> CancelToken {
        
        switch request.task {
        case .normal:
            return sendNormalRequest(request, decisions: decisions, plugins: plugins, handler: handler)
        case .upload(let multipartColumns):
            return sendUploadRequest(request, multiparColumns: multipartColumns, progress: progress, handler: handler)
        }
        
        
    }

    private func sendNormalRequest<Req: HTTPRequest>(
        _ request: Req,
        decisions: [NetworkDecision]? = nil,
        plugins: [HTTPPlugin] = [],
        handler: @escaping (Result<Req.Response, Error>) -> Void
    ) -> CancelToken {
        let request = session.request(request)
            .responseData(completionHandler: { (afResponse: AFDataResponse<Data>) in
                
                guard let httpResponse = afResponse.response else {
                    handler(.failure(NetworkError.Response.nilResponse))
                    return
                }
                
                switch afResponse.result {
                case .success(let data):
                    self.handleDecision(
                        request: request,
                        data: data,
                        response: httpResponse,
                        decisions: decisions ?? request.decisions,
                        plugins: plugins,
                        handler: handler
                    )
                case .failure(let error):
                    handler(.failure(NetworkError.AF.error(error)))
                }
            })
        return CancelToken(request: request)
    }
    
    private func sendUploadRequest<Req: HTTPRequest>(
        _ request: Req,
        multiparColumns: [MultipartColumn],
        decisions: [NetworkDecision]? = nil,
        plugins: [HTTPPlugin] = [],
        progress: @escaping ((Progress) -> Void),
        handler: @escaping (Result<Req.Response, Error>) -> Void
    ) -> CancelToken {
        
        let multipartFormData = MultipartFormData()
        do {
            try multipartFormData.adapted(columns: multiparColumns)
        } catch {
            handler(.failure(error))
        }
        
        let uploadRequest = session.upload(multipartFormData: multipartFormData, with: request)
            .uploadProgress(closure: progress)
            .responseData(completionHandler: { (afResponse: AFDataResponse<Data>) in
                guard let httpResponse = afResponse.response else {
                    handler(.failure(NetworkError.Response.nilResponse))
                    return
                }
                
                switch afResponse.result {
                case .success(let data):
                    self.handleDecision(
                        request: request,
                        data: data,
                        response: httpResponse,
                        decisions: decisions ?? request.decisions,
                        plugins: plugins,
                        handler: handler
                    )
                case .failure(let error):
                    handler(.failure(NetworkError.AF.error(error)))
                }
            })
        return CancelToken(request: uploadRequest)
    }
    
    private func handleDecision<Req: HTTPRequest>(
        request: Req,
        data: Data,
        response: HTTPURLResponse,
        decisions: [NetworkDecision],
        plugins: [HTTPPlugin],
        handler: @escaping (Result<Req.Response, Error>) -> Void
    ) {
        
        print(decisions)
        if decisions.isEmpty {
            handler(.failure(NetworkError.Decision.decisionsIsEmpty))
            return
        }
        
        var decisions = decisions
        let currentDecision = decisions.removeFirst()
        
        if !currentDecision.shouldApply(request: request, data: data, response: response) {
            handleDecision(request: request, data: data, response: response, decisions: decisions, plugins: plugins, handler: handler)
            return
        }

        currentDecision.apply(request: request, data: data, response: response) { action in
            switch action {
            case .next(let request, let data, let response):
                self.handleDecision(request: request, data: data, response: response, decisions: decisions, plugins: plugins, handler: handler)
            case .restart(let decisions):
                self.send(request, decisions: decisions, plugins: plugins, handler: handler)
            case .errored(let error):
                DispatchQueue.main.async {
                    handler(.failure(error))
                }
            case .done(let value):
                DispatchQueue.main.async {
                    handler(.success(value))
                }
            }
        }
    }

}
