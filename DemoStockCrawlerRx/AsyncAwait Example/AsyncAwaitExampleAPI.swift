//
//  AsyncAwaitExampleAPI.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/4/19.
//

import Foundation
import Alamofire

protocol AddressMapAPIProtocol {
    func geocoding(model: NewMultipleAddressModel) async throws -> NewMultipleAddressModel
}

class AddressMapAPIManager: AddressMapAPIProtocol {
    
    func geocoding(model: NewMultipleAddressModel) async throws -> NewMultipleAddressModel {
        let url = ""
        let param:[String:Any] = [:]
        
        let response = await AF.request(url, method: .get, parameters: param, requestModifier: {
            $0.timeoutInterval = 10
        }).serializingResponse(using: .data(emptyResponseCodes: [200]), automaticallyCancelling: true).response
        
        switch response.result {
        case .success(let value):
            let json = try JSONSerialization.jsonObject(with: value) as? [String:Any] ?? [:]
            switch response.response?.statusCode {
            case 200:
                return NewMultipleAddressModel()
            default:
                throw APIError.message("somethine error")
            }
        case .failure(let error):
            switch error {
            case .explicitlyCancelled:
                throw APIError.cancel
            default:
                break
            }
            debugPrint("API Error: \(error)")
            throw APIError.message(error.localizedDescription)
        }
        
    }

}
