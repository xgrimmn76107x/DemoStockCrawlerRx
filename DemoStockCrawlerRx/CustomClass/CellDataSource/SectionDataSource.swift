//
//  SectionDataSource.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import Foundation

enum AutoRegisterType{
    case header, footer, cell
}

class Section{
    var header:RowDataSource?
    var footer:RowDataSource?
    var rows:[RowDataSource] = []
    
    init(header:RowDataSource? = nil, footer:RowDataSource? = nil, rows:[RowDataSource] = []) {
        self.header = header
        self.footer = footer
        self.rows = rows
    }
}

class TableSection:Section{
    var headerTitle:String = ""
    var footerTitle:String = ""
    
    init(headerTitle: String = "", footerTitle: String = "", header:RowDataSource? = nil, footer:RowDataSource? = nil, rows:[RowDataSource] = []) {
        super.init(header: header, footer: footer, rows: rows)
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }
}


