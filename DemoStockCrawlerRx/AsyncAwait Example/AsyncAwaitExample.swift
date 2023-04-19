//
//  AsyncAwaitExample.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/4/19.
//

import Foundation
import Alamofire


enum AddressErrorMsgType {
    case onBoard(errorMsg: String)
    case midWay(index: Int, errorMsg: String)
    case offBoard(errorMsg: String)
}



enum CheckIsModelCompleteError: LocalizedError {
    case onBoard
    case midWay
    case offBoard
    
    var errorDescription: String? {
        switch self {
        case .onBoard:
            return "上車地地址有問題，請重新輸入上車地"
        case .midWay:
            return "停靠點地址有問題，請重新輸入停靠點"
        case .offBoard:
            return "下車地地址有問題，請重新輸入下車地"
        }
    }
}

class ReservationCheckCompletedAddress {
    
    var allAddressModel: [NewMultipleAddressModel] = []
    var onBoardModel: NewMultipleAddressModel = NewMultipleAddressModel()
    var offModel: NewMultipleAddressModel = NewMultipleAddressModel()
    var midwayModel: [NewMultipleAddressModel] = []
    
    private var service: AddressMapAPIProtocol
    
    init(service: AddressMapAPIProtocol) {
        self.service = service
    }
    
    
    func checkModelIsComplete() async throws {
        try await withThrowingTaskGroup(of: AddressErrorMsgType.self) { group in
            
            // 檢查上車地址
            if !self.onBoardModel.isComplete {
                group.addTask {
                    do {
                        let model = try await self.service.geocoding(model: self.onBoardModel)
                        self.onBoardModel = model
                        return .onBoard(errorMsg: "")
                    } catch {
                        return .onBoard(errorMsg: "上車地")
                    }
                }
            }
            // 檢查下車地址 (送機不用檢查，因為只有地址，不需要postcode)
            if !self.offModel.isComplete {
                group.addTask {
                    do {
                        let model = try await self.service.geocoding(model: self.offModel)
                        self.offModel = model
                        return .offBoard(errorMsg: "")
                    } catch {
                        return .offBoard(errorMsg: "下車地")
                    }
                }
            }
            
            // 檢查中途停靠點地址
            for (index, midWay) in midwayModel.enumerated() {
                if !midWay.isComplete {
                    group.addTask {
                        do {
                            let model = try await self.service.geocoding(model: midWay)
                            self.midwayModel[index] = model
                            return .midWay(index: index, errorMsg: "")
                        } catch {
                            return .midWay(index: index, errorMsg: "停靠點\(index + 1)")
                        }
                    }
                }
            }
            // 處理顯示對應的Alert(上車地、停靠點、下車地)
            let count: Int = self.allAddressModel.count
            var alertMessage = Array(repeating: "", count: count)
            
            for try await result in group {
                switch result {
                case .onBoard(errorMsg: let msg):
                    alertMessage[0] = msg
                case .offBoard(errorMsg: let msg):
                    alertMessage[count - 1] = msg
                case .midWay(index: let indx, errorMsg: let msg):
                    alertMessage[1 + indx] = msg
                }
            }
            
            // 判斷是否有錯誤傳出來，如果有的話就顯示對應有問題的Alert(上車地、停靠點、下車地)
            
            let notEmptyMsg: [String] = alertMessage.filter({!$0.isEmpty})
            
            if notEmptyMsg.count > 0 {
                let msg: String = notEmptyMsg.joined(separator: ", ")
                throw APIError.message("\(msg)地址有問題，請重新輸入")
            }
        }
    }
    
}
