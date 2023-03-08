//
//  UIViewController+Extension.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import UIKit


extension UIViewController {
    // MARK: - Navigation Setup
    func navigationSetup(_ text: String, _ tintColor: UIColor = .label) {
        if self == self.navigationController?.viewControllers.first {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cross_black"), style: .plain, target: self, action: #selector(closeBtnPressed))
        }else {
            self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        }

        self.title = text
        self.navigationController?.navigationBar.tintColor = tintColor
    }

    // MARK: - Dismiss
    @objc func closeBtnPressed() {
        // MARK: 判斷是要PopViewController OR Dismiss ViewController
        Tools.popOrDismissViewController(self.navigationController, self)
    }
}
