//
//  NoneCVReusableView.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import UIKit

class NoneCVReusableViewModel: RowDataSource {
    var cellType: CellIdentifier.Type = NoneCVReusableView.self
}

class NoneCVReusableView: UICollectionReusableView, CellConfigurable {
    
    func setData(_ data: RowDataSource) {
        guard let model = data as? NoneCVReusableViewModel else{return}
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

