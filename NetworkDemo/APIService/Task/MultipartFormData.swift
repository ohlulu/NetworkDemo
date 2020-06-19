//
//  MultipartFormData.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/7.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit
import Alamofire

/// Multipar-form-data 的各種類型
public struct MultipartColumn {
    
    public enum FormDataProvider:
    ExpressibleByBooleanLiteral, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
        
        case bool(Bool)
        case string(String)
        case int(Int)
        case image(UIImage)
        case data(Data)
        
        
        public init(booleanLiteral value: BooleanLiteralType) {
            self = .bool(value)
        }
        
        public init(stringLiteral value: StringLiteralType) {
            self = .string(value)
        }
        
        public init(integerLiteral value: IntegerLiteralType) {
            self = .int(value)
        }
        
        public init(_ image: UIImage) {
            self = .image(image)
        }
    }
    
    let provider: FormDataProvider
    let name: String
    let fileName: String?
    let mimeType: String?
    
    public init(provider: FormDataProvider, name: String, fileName: String? = nil, mimeType: String? = nil) {
        self.provider = provider
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

public extension MultipartFormData {
    
    func adapted(columns: [MultipartColumn]) throws {
        for bodyPart in columns {
            switch bodyPart.provider {
            case .bool(let bool):
                append(data: bool.asData(), bodyPart: bodyPart)
            case .string(let str):
                append(data: try str.asData(), bodyPart: bodyPart)
            case .int(let int):
                append(data: int.asData(), bodyPart: bodyPart)
            case .image(let image):
                append(data: try image.asData(), bodyPart: bodyPart)
            case .data(let data):
                append(data: data, bodyPart: bodyPart)
            }
        }
    }
    
    func append(data: Data, bodyPart: MultipartColumn) {
        append(data, withName: bodyPart.name, fileName: bodyPart.fileName, mimeType: bodyPart.mimeType)
    }
}

private extension Bool {
    
    func asData() -> Data {
        
        var valueInInt = Int(truncating: NSNumber(value: self))
        return Data(bytes: &valueInInt, count: MemoryLayout<Bool>.size) //Int to Data
    }
}

private extension String {
    
    func asData() throws -> Data {
        
        if let data = data(using: .utf8) {
            return data
        }
        throw HTTPError.MultipartFormdata.canNotAsData
    }
}

private extension UIImage {
    
    func asData() throws -> Data {
        
        if let data = pngData() {
            return data
        }
        throw HTTPError.MultipartFormdata.canNotAsData
    }
}

private extension Int {
    
    func asData() -> Data {

        var int = self
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
}

private extension Encodable {
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
