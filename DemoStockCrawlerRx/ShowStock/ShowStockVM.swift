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
    
    var insertDataObs: Observable<Range<Int>> {
        return insertDataPublish.asObserver()
    }
    
    /// 搜尋欄輸入
    var keyWords = PublishSubject<String>()
    /// 搜尋按取消
    var cancelBtn = PublishSubject<Void>()
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private(set) public var tableData = TableDataSource()
    
    private(set) public var fullTableData: [TableSection] = []
    
    private(set) public var firstModel: FirstModel!
    
    var perPage: Int { return 15 }
    var totalCount: Int = 15
    var container: [TableSection] = [] {
        didSet {
            tableData.sections = container
        }
    }
    
    
    /// 通知更新
    private var updatePublish = PublishSubject<Void>()
    /// 通知tableInsert
    private var insertDataPublish = PublishSubject<Range<Int>>()
    
    // MARK: - Init
    
    init(data: FirstModel) {
        self.firstModel = data
        
        keyWords.asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, searchText in
                self.filter(searchText)
            }.disposed(by: disposeBag)
        
        cancelBtn.asObserver().subscribe(with: self) { owner, _ in
            owner.filter("")
        }.disposed(by: disposeBag)
    }
    
    // MARK: - 過濾出選擇編號的股票
    func filter(_ text: String) {
        if text == "" {
            container = fullTableData.enumerated().filter({$0.offset < totalCount}).map({$0.element})
        }else {
            if let section = fullTableData.first(where: {$0.footerTitle == text}) {
                container = [section]
            }else {
                container = fullTableData.enumerated().filter({$0.offset < totalCount}).map({$0.element})
            }
        }
        updatePublish.onNext(())
    }
    
    
    // MARK: - Functions
    func getData() {
        var demoStockModel: [ShowStockTVCellModel] = []
        for data in firstModel.data {
            for (index, field) in firstModel.fields.enumerated() {
                demoStockModel.append(ShowStockTVCellModel(field: field, data: data[index]))
            }
            fullTableData.append(TableSection(headerTitle: data[1], footerTitle: data[0], rows: demoStockModel))
            demoStockModel.removeAll()
        }
        container = fullTableData.enumerated().filter({$0.offset < totalCount}).map({$0.element})
        
        
        updatePublish.onNext(())
    }
    
    // MARK: - TableView Will Scroll To
    func willScrollTo(index: Int) {
        // User scrolls to the last item and more items are needed to be fetched
        print("container.count: \(container.count), total: \(totalCount)")
        if index == container.count - 1 && container.count >= totalCount {
            
            totalCount += perPage
            let fromCount = container.count
            container = fullTableData.enumerated().filter({$0.offset < totalCount}).map({$0.element})
            let toCount = container.count
            
            let indicesToBeInserted = fromCount..<toCount
            insertDataPublish.onNext(indicesToBeInserted)
        }
    }
    
}

