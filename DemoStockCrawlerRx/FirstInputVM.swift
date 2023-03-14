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
    
    var completeGetDataObs: Observable<FirstModel> {
        return completeGetDataPublish.asObservable()
    }
    
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private(set) public var tableData = TableDataSource()
    
    private(set) public var dateStr: String = ""
    
    private(set) public var data: FirstModel!
    
    private var completeGetDataPublish = PublishSubject<FirstModel>()
    
    // MARK: - Init
    
    
    
    // MARK: - Functions
    
    func getData(dateStr: String) async throws {
        let tempDateStr = dateStr.replacingOccurrences(of: "/", with: "")
        self.data = try await FirstAPI.getStock(dateStr: tempDateStr)
        
    }
    
    func moyaGetData(dateStr: String) {
        Tools.showHud()
        APIManager.shared.request(StockService.SearchAll(dateStr: dateStr)).subscribe(with: self) { owner, firstModel in
            Tools.hideHud()
            if firstModel.stat == "OK" {
                owner.completeGetDataPublish.onNext(firstModel)
            }else {
                Tools.showMessage(title: "Notice", message: firstModel.stat, buttonList: ["got it"])
            }
        } onFailure: { owner, error in
            Tools.hideHud()
            Tools.showMessage(title: "Notice", message: error.localizedDescription, buttonList: ["got it"])
        }.disposed(by: disposeBag)

    }
    
    
}


