//
//  RowDataSource.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import Foundation

protocol RowDataSource {
    var cellType:CellIdentifier.Type {get set}
}
