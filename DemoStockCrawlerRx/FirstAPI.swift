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

class FirstAPI {
    

    static func getStock(dateStr: String) async throws -> FirstModel {
        let url = "https://www.twse.com.tw/zh/exchangeReport/MI_INDEX"
        let param:[String:Any] = [
            "date": dateStr,
            "type":"ALL"
        ]
        
        let response = await AF.request(url, method: .get, parameters: param, requestModifier: {
            $0.timeoutInterval = 15
        }).serializingResponse(using: .data(emptyResponseCodes: [200, 400]), automaticallyCancelling: true).response
        
        switch response.result {
        case .success(let value):
            let json = try JSONSerialization.jsonObject(with: value) as? [String:Any] ?? [:]
            switch response.response?.statusCode {
            case 200:
                let data = FirstModel(JSON: json)
                return data ?? FirstModel()
            case 400:
                let message = json["Message"] as? String ?? ""
                throw APIError.message(message)
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
        }
        
        throw APIError.message("Something Error")
    }
}

