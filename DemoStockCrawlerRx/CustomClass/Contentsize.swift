//
//  Contentsize.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/13.
//

import Foundation
import UIKit


class ContentSizeTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}


class ContentSizeCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return collectionViewLayout.collectionViewContentSize
    }
}

