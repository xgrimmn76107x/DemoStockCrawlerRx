//
//  CellDataModel.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import UIKit

protocol CellDataModel{
    associatedtype DataModelType
    func setDataModel(_ dataModel:DataModelType)
}


protocol CellConfigurable{
    func setData(_ data:RowDataSource)
}

