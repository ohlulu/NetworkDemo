//
//  MultipartFormData.swift
//  NetworkDemo
//
//  Created by Ohlulu on 2020/6/7.
//  Copyright © 2020 ohlulu. All rights reserved.
//

import UIKit
import Alamofire

public struct MultipartColumn {
    
    public enum FormDataProvider: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
        
        case string(String)
        case int(Int)
        case image(UIImage)
        case data(Data)
        
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
    
    static func parseFrom<T: Encodable>(_ model: T) throws -> [MultipartColumn] {
        
        let dic = try model.asDictionary()
        
        let mirror = Mirror(reflecting: dic)
        var columns = [MultipartColumn]()
        for child in mirror.children {
            
            guard let label = child.label else {
                throw NetworkError.MultipartFormdata.labelIsNil
            }
            
            if child.value is String {
                let column = try parse(string: child.value, label: label)
                columns.append(column)
            } else if child.value is Int {
                let column = try parse(int: child.value, label: label)
                columns.append(column)
            } else if child.value is UIImage {
               let column = try parse(image: child.value, label: label)
               columns.append(column)
            } else if child.value is Data {
                guard let data = child.value as? Data else {
                    throw NetworkError.MultipartFormdata.canNotParseTypeToData
                }
                let column = MultipartColumn(provider: .data(data), name: label)
                columns.append(column)
            } else {
                throw NetworkError.MultipartFormdata.canNotParseTypeToData
            }
        }
        return columns
    }
    
    private static func parse(string: Any, label: String) throws -> MultipartColumn {
        if let value = string as? String {
            let column = MultipartColumn(provider: .string(value), name: label)
            return column
        }
        
        throw NetworkError.MultipartFormdata.parseString
    }
    
    private static func parse(int: Any, label: String) throws -> MultipartColumn {
        if let value = int as? Int {
            let column = MultipartColumn(provider: .int(value), name: label)
            return column
        }
        
        throw NetworkError.MultipartFormdata.parseInt
    }
    
    private static func parse(image: Any, label: String) throws -> MultipartColumn {
        if let value = image as? UIImage {
            let column = MultipartColumn(provider: .image(value), name: label)
            return column
        }
        
        throw NetworkError.MultipartFormdata.parseImage
    }
}

public extension MultipartFormData {
    
    func adapted(columns: [MultipartColumn]) throws {
        for bodyPart in columns {
            switch bodyPart.provider {
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


private extension String {
    
    func asData() throws -> Data {
        if let data = data(using: .utf8) {
            return data
        }
        throw NetworkError.MultipartFormdata.canNotAsData
    }
}

private extension UIImage {
    
    func asData() throws -> Data {
        if let data = pngData() {
            return data
        }
        throw NetworkError.MultipartFormdata.canNotAsData
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
