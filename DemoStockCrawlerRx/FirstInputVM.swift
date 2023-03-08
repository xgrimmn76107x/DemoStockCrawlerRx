//
//  FirstInputVM.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8 4:23 PM.
//

import Foundation
import RxSwift


class FirstInputVM {
    // MARK: - Output
    
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private(set) public var tableData = TableDataSource()
    
    private(set) public var dateStr: String = ""
    
    private(set) public var data: FirstModel!
    
    // MARK: - Init
    
    
    
    // MARK: - Functions
    
    func getData(dateStr: String) async {
        let tempDateStr = dateStr.replacingOccurrences(of: "/", with: "")
        async let data = FirstAPI.getStock(dateStr: dateStr)
        do {
            self.data = try await data
        } catch APIError.message(let msg) {
            Tools.showMessage(title: "Notice", message: msg, buttonList: ["got it"], completion: nil)
        } catch APIError.cancel {
            print("API Cancel do notthing")
        } catch let error {
            print(error)
        }
        
    }
    
    
}


