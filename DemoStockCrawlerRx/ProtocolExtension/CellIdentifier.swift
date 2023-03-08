//
//  CellIdentifier.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import Foundation

protocol CellIdentifier{
}

extension CellIdentifier{
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
