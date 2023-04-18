//
//  Present.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/4/18.
//

import Foundation
import UIKit

protocol PresentProtocol: AnyObject {
    func presentWithUINavigationOnTop(_ viewController: UIViewController, presentStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle)
}


extension PresentProtocol where Self: UIViewController {
    func presentWithUINavigationOnTop(_ viewController: UIViewController, presentStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle) {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = presentStyle
            nav.modalTransitionStyle = transitionStyle
            self.present(nav, animated: true)
        }
    }
}
