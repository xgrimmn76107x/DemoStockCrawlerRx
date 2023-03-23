//
//  ShowStockDiffableCVCell.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/18.
//

import UIKit

class ShowStockDiffableCVCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    var showStockCellModel: StockItem = StockItem(title: "", content: "") {
        didSet {
            titleLabel.text = showStockCellModel.title
            subTitleLabel.text = showStockCellModel.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
