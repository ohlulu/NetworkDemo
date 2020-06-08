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
}
