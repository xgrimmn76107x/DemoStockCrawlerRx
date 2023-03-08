//
//  FirstModel.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import Foundation
import ObjectMapper

class FirstModel: Mappable {
    var stat: String = ""
    var fields9: [String] = []
    var data9: [[String]] = []
    
    
    init() {}
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        stat <- map["stat"]
        fields9 <- map["fields9"]
        data9 <- map["data9"]
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

