//
//  ShowStockVM.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8 4:31 PM.
//

import UIKit
import RxSwift
import RxCocoa


class ShowStockVM {
    // MARK: - Output
    
    var updateObs: Observable<Void> {
        return updatePublish.asObserver()
    }
    
    var keyWords = PublishSubject<String>()
    
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private(set) public var tableData = TableDataSource()
    
    private(set) public var fullTableData: [TableSection] = []
    
    private(set) public var firstModel: FirstModel!
    
    
    /// 通知更新
    private var updatePublish = PublishSubject<Void>()
    
    // MARK: - Init
    
    init(data: FirstModel) {
        self.firstModel = data
        getData()
        
        keyWords.asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, searchText in
                self.filter(searchText)
            }.disposed(by: disposeBag)
    }
    
    // MARK: - 過濾出選擇編號的股票
    func filter(_ text: String) {
        if text == "" {
            tableData.sections = fullTableData
        }else {
            if let section = tableData.sections.first(where: {$0.footerTitle == text}) {
                tableData.sections = [section]
            }else {
                tableData.sections = fullTableData
            }
        }
        updatePublish.onNext(())
    }
    
    
    // MARK: - Functions
    func getData() {
        var demoStockModel: [ShowStockTVCellModel] = []
        for data in firstModel.data9 {
            for (index, field) in firstModel.fields9.enumerated() {
                demoStockModel.append(ShowStockTVCellModel(field: field, data: data[index]))
            }
            fullTableData.append(TableSection(headerTitle: data[1], footerTitle: data[0], rows: demoStockModel))
            demoStockModel.removeAll()
        }
        tableData.sections = fullTableData
        
        Tools.hideHud()
        
        updatePublish.onNext(())
    }
    
}

