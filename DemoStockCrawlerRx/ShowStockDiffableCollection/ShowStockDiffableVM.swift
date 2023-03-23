//
//  ShowStockDiffableVM.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/17.
//

import UIKit
import RxSwift
import RxCocoa

enum SettingList: Hashable {
    case header(StockHeader)
    case item(StockItem)
}

struct StockHeader: Hashable {
    var name: String
    var items: [StockItem]
    public static func == (lhs: StockHeader, rhs: StockHeader) -> Bool {
        return lhs.name == rhs.name
    }
}
struct StockItem: Hashable {
    var title: String
    var content: String
    
}

class ShowStockDiffableVM {
//    typealias DataSourceSnapShot = NSDiffableDataSourceSectionSnapshot<SettingList>
    typealias DataSourceSnapShot = NSDiffableDataSourceSnapshot<String, StockItem>
    
    // MARK: - Output
    
    // bind update Snap Shot
    var updateSnapShot: ((DataSourceSnapShot) -> Void)?
    
    /// 搜尋欄輸入
    var keyWords = PublishSubject<String>()
    /// 搜尋按取消
    var cancelBtn = PublishSubject<Void>()
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private(set) public var firstModel: FirstModel!
    
    private(set) public var fullData: [StockHeader] = []
    
    private(set) public var container: [StockHeader] = [] {
        didSet {
            applySnapShot()
        }
    }
    
    private var snapshot = DataSourceSnapShot()
    
    
    var perPage: Int { return 15 }
    var totalCount: Int = 15
    
    
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
    
    
    // MARK: - Functions
    
    // MARK: Set SnapShot
    func applySnapShot() {
        snapshot = DataSourceSnapShot()
        for data in container {
            snapshot.appendSections([data.name])
            snapshot.appendItems(data.items)
//            let header = SettingList.header(data)
//            snapshot.append([header])
//            snapshot.append(data.items.map({SettingList.item($0)}), to: header)
        }
        updateSnapShot?(snapshot)
        
    }
    
    // MARK: - 過濾出選擇編號的股票
    func filter(_ text: String) {
        if text == "" {
            container = fullData.enumerated().filter({$0.offset < totalCount}).map({$0.element})
        }else {
            
            if text.count >= 3 {
                let section = fullData.filter({$0.items[0].content.contains(text)})
                container = section
            }else {
                container = fullData.enumerated().filter({$0.offset < totalCount}).map({$0.element})
            }
        }
    }
    
    func processData() {
        var tempStockItems: [StockItem] = []
        for data in firstModel.data {
            for (index, field) in firstModel.fields.enumerated() {
                tempStockItems.append(StockItem(title: field, content: data[index]))
            }
            fullData.append(StockHeader(name: data[1], items: tempStockItems))
            tempStockItems.removeAll()
        }
        container = fullData.enumerated().filter({$0.offset < totalCount}).map({$0.element})
        
    }
    
    // MARK: - ColectionView Will Scroll To
    func willScrollTo(index: Int) {
        // User scrolls to the last item and more items are needed to be fetched
        print("container.count: \(container.count), total: \(totalCount)")
        if index == container.count - 1 && container.count >= totalCount {
            
            totalCount += perPage
            container = fullData.enumerated().filter({$0.offset < totalCount}).map({$0.element})
            
        }
    }
    
}
