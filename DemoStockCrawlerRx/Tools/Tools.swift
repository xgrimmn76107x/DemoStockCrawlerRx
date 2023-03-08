//
//  Tools.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/3/8.
//

import Foundation
import UIKit
import MBProgressHUD

class Tools {
    
    static func showMessage(title: String, message: String, buttonList: [String], completion: ((Int) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actions = setMultiActions(buttonList) { index in
            completion?(index)
        }
        alertController.addActions(actions: actions)
        presentViewController(alertController)
    }
    
    // MARK: - Set Multi Alert
    class func setMultiActions(_ actions: [String], handler: ((Int) -> Void)? = nil) -> [UIAlertAction] {
        var alertActions: [UIAlertAction] = []
        for (index, actionTitle) in actions.enumerated() {
            alertActions.append(UIAlertAction(title: actionTitle, style: .default) { _ in
                handler?(index)
            })
        }
        
        return alertActions
    }
        
    
    // MARK: - present
    static func presentViewController(_ viewController: UIViewController) {
        let presentedViewController = getLastPresentedViewController()
        DispatchQueue.main.async(execute: {
            presentedViewController?.present(viewController, animated: true)
        })
    }
    
    // MARK: - present With UINavigation
    static func presentWithUINavigationOnTop(_ viewController:UIViewController, presentStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .coverVertical){
        let presentedViewController = getLastPresentedViewController()
        DispatchQueue.main.async(execute: {
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = presentStyle
            nav.modalTransitionStyle = transitionStyle
            presentedViewController?.present(nav, animated: true)
        })
        
    }
    // MARK: - 得到最後Presented ViewController
    static func getLastPresentedViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
//            .filter({$0.activationState == .foregroundActive}) // 如果是DeepLink回來的話就不見得在前景，因此不過濾了
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        var presentedViewController = keyWindow?.rootViewController
        while presentedViewController?.presentedViewController != nil {
            presentedViewController = presentedViewController?.presentedViewController
        }
        return presentedViewController
    }
    
    static func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController
        {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController
        {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController
        {
            return currentViewController(base: presented)
        }
        return base
    }
    
    // MARK: - 判斷是要PopViewController OR Dismiss ViewController
    static func popOrDismissViewController(_ naviController: UINavigationController? = currentViewController()?.navigationController, _ viewController: UIViewController, completion: (() -> Void)? = nil) {
        if naviController?.children.count ?? 0 <= 1 {
            viewController.dismiss(animated: true, completion: completion)
        }else {
            naviController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Show Hud
    static func showHud(title: String = "processing") {
        DispatchQueue.main.async {
            guard let view = UIApplication.shared.keyWindow else { return }
            let hud = MBProgressHUD.showAdded(to: view, animated: false)
            hud.animationType = .fade
            hud.label.numberOfLines = 0
            if title != "" {
                hud.label.text = title
            }
        }
    }
    
    // MARK: - Hide Hud
    static func hideHud() {
        DispatchQueue.main.async {
            guard let view = UIApplication.shared.keyWindow else { return }
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
}

