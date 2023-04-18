//
//  Alert.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/4/18.
//

import Foundation
import UIKit


protocol AlertProtocol {
    func showAlert(title: String, message: String, buttonList: [String], completion: ((Int) -> Void)?)
}


extension AlertProtocol where Self: UIViewController {
    func showAlert(title: String, message: String, buttonList: [String], completion: ((Int) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actions = setMultiActions(buttonList) { index in
            completion?(index)
        }
        alertController.addActions(actions: actions)
        self.present(alertController, animated: true)
    }
    
    private func setMultiActions(_ actions: [String], handler: ((Int) -> Void)? = nil) -> [UIAlertAction] {
        var alertActions: [UIAlertAction] = []
        for (index, actionTitle) in actions.enumerated() {
            alertActions.append(UIAlertAction(title: actionTitle, style: .default) { _ in
                handler?(index)
            })
        }
        
        return alertActions
    }
}
