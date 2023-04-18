//
//  ShowStockDiffableVC.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/17.
//

import UIKit
import RxSwift
import RxCocoa


class ShowStockDiffableVC: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<String, StockItem>
    

    @IBOutlet weak var collection: UICollectionView!
    
    var searchController: UISearchController!
    
    let disposeBag = DisposeBag()
    
    var viewModel: ShowStockDiffableVM!
    
    private var dataSource: DataSource!
    
    private var cellRegistration: UICollectionView.CellRegistration<ShowStockDiffableCVCell, StockItem>!
    
    
    
    convenience init(data: FirstModel) {
        self.init()
        viewModel = ShowStockDiffableVM(data: data)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchSetup()
        configureCollectionDataSource()
        collectionSetup()
        bindings()
        navigationSetup("篩選想要的股票")
        
        viewModel.processData()
    }
    
    func bindings() {
        viewModel.updateSnapShot = { [weak self] snapshot in
            DispatchQueue.main.async {
                self?.dataSource.apply(snapshot)
            }
        }
    }
    
    
    func searchSetup() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.keyWords)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked
            .bind(to: viewModel.cancelBtn)
            .disposed(by: disposeBag)
    }


    func collectionSetup() {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collection.delegate = self
        collection.dataSource = dataSource
        collection.collectionViewLayout = layout
        collection.register(UINib(nibName: ShowStockDiffableCVCell.cellIdentifier(), bundle: .main), forCellWithReuseIdentifier: ShowStockDiffableCVCell.cellIdentifier())
        
        
    }
    
    func makeDataSource() -> DataSource {

        let cellRegistration = UICollectionView.CellRegistration<ShowStockDiffableCVCell, StockItem> { cell, indexPath, itemIdentifier in
            cell.showStockCellModel = itemIdentifier
        }

        return DataSource(collectionView: collection, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowStockDiffableCVCell.cellIdentifier(), for: indexPath) as! ShowStockDiffableCVCell
//            cell.showStockCellModel = itemIdentifier
            return cell
        })
    }
    
    func configureCollectionDataSource() {
        let headerReg = UICollectionView.CellRegistration<UICollectionViewListCell, StockHeader> { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.name
            cell.contentConfiguration = content
            
            
            
        }
        
        cellRegistration = UICollectionView.CellRegistration<ShowStockDiffableCVCell, StockItem> { cell, indexPath, itemIdentifier in
            cell.showStockCellModel = itemIdentifier
        }
        
        
//        dataSource = DataSource(collectionView: collection, cellProvider: { collectionView, indexPath, itemIdentifier in
//            switch itemIdentifier {
//            case .header(let headerTitle):
//                let cell = collectionView.dequeueConfiguredReusableCell(using: headerReg, for: indexPath, item: headerTitle)
//                return cell
//            case .item(let item):
//                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
//                return cell
//            }
//        })
        
        dataSource = DataSource(collectionView: collection, cellProvider: { collectionView, indexPath, itemIdentifier in
//            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowStockDiffableCVCell.cellIdentifier(), for: indexPath) as! ShowStockDiffableCVCell
            cell.showStockCellModel = itemIdentifier
            return cell
        })
    }

    
}


extension ShowStockDiffableVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willScrollTo(index: indexPath.section)
    }
}
