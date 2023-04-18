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
    
    private var service: FirstAPIProtocol
    
    private(set) public var tableData = TableDataSource()
    
    private(set) public var dateStr: String = ""
    
    private(set) public var data: FirstModel!
    
    private var completeGetDataPublish = PublishSubject<FirstModel>()
    
    // MARK: - Init
    init(service: FirstAPIProtocol) {
        self.service = service
    }
    
    
    // MARK: - Functions
    
    func getData(dateStr: String) async throws {
        let tempDateStr = dateStr.replacingOccurrences(of: "/", with: "")
        self.data = try await service.getStock(dateStr: tempDateStr)
        
    }
    
    func moyaGetData(dateStr: String) {
        let tempDateStr = dateStr.replacingOccurrences(of: "/", with: "")
        Tools.showHud()
        APIManager.shared.request(StockService.SearchAll(dateStr: tempDateStr)).subscribe(with: self) { owner, data in
            Tools.hideHud()
            if let firstModel = data.tables.first(where: {$0.title.contains("每日收盤行情(全部)")}) {
                owner.completeGetDataPublish.onNext(firstModel)
            }else {
                Tools.showMessage(title: "Notice", message: "No Data", buttonList: ["got it"])
            }
        } onFailure: { owner, error in
            Tools.hideHud()
            Tools.showMessage(title: "Notice", message: error.localizedDescription, buttonList: ["got it"])
        }.disposed(by: disposeBag)

    }
    
    
}


