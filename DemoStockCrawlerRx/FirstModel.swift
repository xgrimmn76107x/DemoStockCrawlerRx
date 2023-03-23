//
//  FirstModel.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import Foundation
import ObjectMapper

struct FirstResponseModel: Mappable {
    var tables: [FirstModel] = []
    var stat: String = ""
    
    init() {}
    init?(map: ObjectMapper.Map) {}
    
    mutating func mapping(map: ObjectMapper.Map) {
        stat <- map["stat"]
        tables <- map["tables"]
    }
    
    
}

struct FirstModel: Mappable {
    var title: String = ""
    var fields: [String] = []
    var data: [[String]] = []
    
    
    init() {}
    
    init?(map: ObjectMapper.Map) {}
    
    mutating func mapping(map: ObjectMapper.Map) {
        title <- map["title"]
        fields <- map["fields"]
        data <- map["data"]
    }
    
    
}

/*
 "證券代號",
 "證券名稱",
 "成交股數",
 "成交筆數",
 "成交金額",
 "開盤價",
 "最高價",
 "最低價",
 "收盤價",
 "漲跌(+/-)",
 "漲跌價差",
 "最後揭示買價",
 "最後揭示買量",
 "最後揭示賣價",
 "最後揭示賣量",
 "本益比",
 */

