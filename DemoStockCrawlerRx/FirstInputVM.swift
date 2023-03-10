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
    
    func getData(dateStr: String) async throws {
        let tempDateStr = dateStr.replacingOccurrences(of: "/", with: "")
        self.data = try await FirstAPI.getStock(dateStr: tempDateStr)
        
    }
    
    
}


