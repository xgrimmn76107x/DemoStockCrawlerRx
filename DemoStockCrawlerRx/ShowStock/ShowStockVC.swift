//
//  ShowStockVC.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8 4:31 PM.
//


import UIKit
import RxSwift
import RxCocoa


class ShowStockVC: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    
    var searchController: UISearchController!
    
    let disposeBag = DisposeBag()
    
    var viewModel: ShowStockVM!
    
    convenience init(data: FirstModel) {
        self.init()
        viewModel = ShowStockVM(data: data)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindings()
        searchSetup()
        tableSetup()
        navigationSetup("篩選想要的股票")
        
        
    }
    
    func searchSetup() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchBar.rx.text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.keyWords)
            .disposed(by: disposeBag)
    }
    
    

    func bindings(){
        viewModel.updateObs.subscribe(with: self) { owner, _ in
            owner.table.reloadData()
        }.disposed(by: disposeBag)
        
        
//        textField.rx.text
//            .orEmpty
//            .debounce(.seconds(1), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .bind(to: viewModel.keyWords)
//            .disposed(by: disposeBag)
    }
    
    func tableSetup() {
        viewModel.tableData.bindTable(table)
        
        table.delegate = self
    }
}

extension ShowStockVC: UITableViewDelegate {
    
}
