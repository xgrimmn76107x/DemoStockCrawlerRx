//
//  ShowStockTVCell.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8 4:31 PM.
//


import UIKit
import RxSwift
import RxCocoa

struct ShowStockTVCellModel: RowDataSource {
    var cellType: CellIdentifier.Type = ShowStockTVCell.self
    var field: String = ""
    var data: String = ""
    
}

class ShowStockTVCell: UITableViewCell, CellConfigurable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    var disposeBag:DisposeBag?
    
    func setData(_ data: RowDataSource) {
        guard let model = data as? ShowStockTVCellModel else{return}
        disposeBag = DisposeBag()
        titleLabel.text = model.field
        subTitleLabel.text = model.data
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}




