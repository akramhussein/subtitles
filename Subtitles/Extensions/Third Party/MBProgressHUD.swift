//
//  MBProgressHUD.swift
//  AHUtils
//
//  Created by Akram Hussein on 09/05/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.

import MBProgressHUD

public extension MBProgressHUD {
    static func createHUD(view: UIView, message: String) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = message
        return hud
    }
    
    static func createCompletionHUD(view: UIView, message: String) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.setHUDToComplete(message: message)
        return hud
    }
    
    static func createFailedHUD(view: UIView, message: String) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.setHUDToFailed(message: message)
        return hud
    }
    
    static func createSimpleHUD(view: UIView, message: String) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = message
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 2)
        return hud
    }
    
    static func createLoadingHUD(view: UIView, message: String) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = message
        hud.removeFromSuperViewOnHide = true
        return hud
    }
    
    func setHUDToComplete(message: String = "", detailsMessage: String? = nil, delay: Double = 1.0) {
        self.setHUDEndStatusWithImage(message: message, detailsMessage: detailsMessage, imagePath: "HudCheckmark", delay: delay)
    }
    
    func setHUDToFailed(message: String = "", detailsMessage: String? = nil, delay: Double = 1.0) {
        self.setHUDEndStatusWithImage(message: message, detailsMessage: detailsMessage, imagePath: "HudCross", delay: delay)
    }
    
    func setHUDEndStatusWithImage(message: String, detailsMessage: String? = nil, imagePath: String, delay: Double = 1.0) {
        let image = UIImage(named: imagePath)
        let imageView = UIImageView(image: image)
        self.customView = imageView
        self.mode = .customView
        self.label.text = message
        self.detailsLabel.text = detailsMessage
        self.removeFromSuperViewOnHide = true
        self.hide(animated: true, afterDelay: delay)
    }
    
    func setHUDEndStatus(message: String, detailsMessage: String? = nil, delay: Double = 1.0) {
        self.mode = .customView
        self.label.text = message
        self.detailsLabel.text = detailsMessage
        self.removeFromSuperViewOnHide = true
        self.hide(animated: true, afterDelay: delay)
    }
}
