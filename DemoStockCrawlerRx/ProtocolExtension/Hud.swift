//
//  Hud.swift
//  DemoStockCrawlerRx
//
//  Created by mtaxi on 2023/4/19.
//

import Foundation
import MBProgressHUD

protocol HUDProtocol {
    
    func showLoadingHUD(view: UIView)
    func showLoadingHUD(view: UIView, text: String)
    func hideHud(view: UIView)
}

extension HUDProtocol where Self: UIView {
    func showLoadingHUD(text: String) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self, animated: false)
            hud.animationType = .fade
            hud.label.numberOfLines = 0
            if text != "" {
                hud.label.text = text
            }
        }
    }
}

class MBPHud: HUDProtocol {
    func showLoadingHUD(view: UIView) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: view, animated: false)
            hud.animationType = .fade
        }
    }
    
    func showLoadingHUD(view: UIView, text: String) {
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: view, animated: false)
            hud.animationType = .fade
            hud.label.numberOfLines = 0
            if text != "" {
                hud.label.text = text
            }
        }
    }
    
    func hideHud(view: UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    
}
