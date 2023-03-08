//
//  TableDataSource.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import UIKit

class TableDataSource: NSObject, UITableViewDataSource {
    var sections:[TableSection] = []{
        didSet{
            if(self.cells.count == 0){
                self.registerCells()
            }
        }
    }
    
    var cells: [UITableViewCell.Type] = []
    
    private var registered:[String:Bool] = [:]
    private var table:UITableView?
    
    func data(at indexPath:IndexPath) -> RowDataSource{
        return self.sections[indexPath.section].rows[indexPath.row]
    }
    
    func append(headerTitle:String = "", footerTitle: String = "", header:RowDataSource? = nil, footer:RowDataSource? = nil, rows:[RowDataSource]){
        self.sections.append(TableSection(headerTitle:headerTitle, footerTitle:footerTitle, header: header, footer: footer, rows: rows))
    }
    
    func bindTable(_ tableView: UITableView){
        self.table = tableView
        self.table?.dataSource = self
        self.registerCells()
    }
    
    func registerCells(_ cells:[UITableViewCell.Type], tableView: UITableView){
        self.cells = cells
        self.table = tableView
        self.table?.dataSource = self
        cells.forEach({tableView.register(UINib(nibName: $0.cellIdentifier(), bundle: .main), forCellReuseIdentifier: $0.cellIdentifier())})
    }
    
    func registerCells(){
        if(self.table == nil){
            return
        }
        for s in self.sections{
            for r in s.rows{
                let str = r.cellType.cellIdentifier()
                if(registered[str] == nil){
                    registered[str] = true
                    self.table?.register(UINib(nibName: str, bundle: nil), forCellReuseIdentifier: str)
                }
            }
        }
    }
    
    //MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.data(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: data.cellType.cellIdentifier(), for: indexPath)
        (cell as? CellConfigurable)?.setData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        return section.headerTitle
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = self.sections[section]
        return section.footerTitle
    }
}


