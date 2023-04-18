//
//  FirstAPI.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import Foundation
import Alamofire

enum APIError: LocalizedError {
    case message(String)
    case cancel
    
    var errorDescription: String? {
        switch self {
        case .message(let string):
            return string
        case .cancel:
            return ""
        }
    }
}

protocol FirstAPIProtocol {
    func getStock(dateStr: String) async throws -> FirstModel
}

class FirstAPI: FirstAPIProtocol {
    

    func getStock(dateStr: String) async throws -> FirstModel {
        Tools.showHud()
        let url = "https://www.twse.com.tw/zh/exchangeReport/MI_INDEX"
        let param:[String:Any] = [
            "date": dateStr,
            "type":"ALL"
        ]
        
        let response = await AF.request(url, method: .get, parameters: param, requestModifier: {
            $0.timeoutInterval = 10
        }).serializingResponse(using: .data(emptyResponseCodes: [200]), automaticallyCancelling: true).response
        
        Tools.hideHud()
        switch response.result {
        case .success(let value):
            let json = try JSONSerialization.jsonObject(with: value) as? [String:Any] ?? [:]
            switch response.response?.statusCode {
            case 200:
                let data = FirstResponseModel(JSON: json)
                if let firstModel = data?.tables.first(where: {$0.title.contains("每日收盤行情(全部)")}) {
                    return firstModel
                }else {
                    throw APIError.message(data?.stat ?? "Something Error")
                }
            default:
                break
            }
        case .failure(let error):
            switch error {
            case .explicitlyCancelled:
                throw APIError.cancel
            default:
                break
            }
            debugPrint("API Error: \(error)")
            throw error
        }
        
        throw APIError.message("Something Error")
    }
}

