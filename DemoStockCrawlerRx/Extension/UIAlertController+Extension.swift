//
//  UIAlertController+Extension.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import UIKit

extension UIAlertController {
    func addActions(actions: [UIAlertAction], preferred: String? = nil) {
        
        for action in actions {
            self.addAction(action)
            
            if let preferred = preferred, preferred == action.title {
                self.preferredAction = action
            }
        }
    }
}
