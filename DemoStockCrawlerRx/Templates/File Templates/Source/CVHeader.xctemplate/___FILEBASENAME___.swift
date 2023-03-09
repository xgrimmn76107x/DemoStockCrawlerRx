//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___ ___TIME___.
//


import UIKit
import RxSwift
import RxCocoa
import RxBiBinding

struct ___FILEBASENAMEASIDENTIFIER___Model: RowDataSource {
    var cellType: CellIdentifier.Type = ___FILEBASENAMEASIDENTIFIER___.self
}

class ___FILEBASENAMEASIDENTIFIER___: UICollectionReusableView, CellConfigurable {
    var disposeBag:DisposeBag?
    var vm:___FILEBASENAMEASIDENTIFIER___Model?
    
    func setData(_ data: RowDataSource) {
        guard let model = data as? ___FILEBASENAMEASIDENTIFIER___Model else{return}
        disposeBag = DisposeBag()
        vm = model
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
