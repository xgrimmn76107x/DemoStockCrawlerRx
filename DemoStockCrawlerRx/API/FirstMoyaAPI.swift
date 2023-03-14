//
//  FirstMoyaAPI.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/14.
//

import Foundation
import Moya
import ObjectMapper
import RxSwift


private protocol AddressAPITagetType: MappableResponseTargetType{}

extension AddressAPITagetType {
    var baseURL: URL { return URL(string: "https://www.twse.com.tw/zh/exchangeReport")!}
    var headers: [String : String]? { return ["Content-Type": "application/json"] }
    var sampleData: Data { return Data()}
}

enum StockService {
    struct SearchAll: AddressAPITagetType{
        typealias ResponseType = FirstModel
        
        var path: String { return "/MI_INDEX" }
        
        var method: Moya.Method { return .get }
        
        var task: Task { return .requestParameters(parameters: param, encoding: URLEncoding.default) }
        
        private let param: [String:Any]
        
        init(dateStr: String) {
            self.param = [
                "date": dateStr,
                "type":"ALL"
            ]
        }
    }
}

