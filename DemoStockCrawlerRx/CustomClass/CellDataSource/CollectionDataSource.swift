//
//  CollectionDataSource.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import UIKit

class CollectionDataSource: NSObject, UICollectionViewDataSource {
    var sections:[Section] = []{
        didSet{
            if(self.cells.count == 0){
                self.registerCells()
            }
        }
    }
    
    var cells: [UITableViewCell.Type] = []
    
    private var registered:[String:Bool] = [:]
    private var collection:UICollectionView?
    
    func data(at indexPath:IndexPath) -> RowDataSource{
        return self.sections[indexPath.section].rows[indexPath.row]
    }
    
    func append(header:RowDataSource? = nil, footer:RowDataSource? = nil, rows:[RowDataSource]){
        self.sections.append(Section(header: header, footer: footer, rows: rows))
    }
    
    func bindCollectionView(_ collectionView:UICollectionView){
        self.collection = collectionView
        self.collection?.dataSource = self
        self.registerCells()
    }
    func registerCells(_ cells:[UITableViewCell.Type], tableView: UITableView){
        self.cells = cells
        self.collection?.dataSource = self
        cells.forEach({self.collection?.register(UINib(nibName: $0.cellIdentifier(), bundle: .main), forCellWithReuseIdentifier: $0.cellIdentifier())})
    }
    
    func registerCells(){
        if(self.collection == nil){
            return
        }
        for s in self.sections{
            if let h = s.header{
                self.register(identifier: h.cellType.cellIdentifier(), type: .header)
            }else{
                self.register(identifier: NoneCVReusableView.cellIdentifier(), type: .header)
            }
            if let f = s.footer{
                self.register(identifier: f.cellType.cellIdentifier(), type: .footer)
            }else{
                self.register(identifier: NoneCVReusableView.cellIdentifier(), type: .footer)
            }
            for r in s.rows{
                let str = r.cellType.cellIdentifier()
                self.register(identifier: str, type: .cell)
            }
        }
    }
    
    func register(identifier:String, type:AutoRegisterType){
        if(registered[identifier] == nil){
            registered[identifier] = true
            switch type {
            case .header:
                self.collection?.register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
                break
            case .footer:
                self.collection?.register(UINib(nibName: identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
                break
            case .cell:
                self.collection?.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
                break
            }
        }
    }
    
//    func update(indexPath:IndexPath, data:RowDataSource){
//        self.sections[indexPath.section].rows[indexPath.row] = data
//        self.collection?.reloadItems(at: [indexPath])
//    }
    
    //MARK: - UICollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = self.data(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: data.cellType.cellIdentifier(), for: indexPath)
        (cell as? CellConfigurable)?.setData(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if let data = self.sections[indexPath.section].header{
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: data.cellType.cellIdentifier(), for: indexPath)
                (header as? CellConfigurable)?.setData(data)
                return header
            }
        case UICollectionView.elementKindSectionFooter:
            if let data = self.sections[indexPath.section].footer{
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: data.cellType.cellIdentifier(), for: indexPath)
                (header as? CellConfigurable)?.setData(data)
                return header
            }
        default:
            break
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NoneCVReusableView.cellIdentifier(), for: indexPath)
    }
}


