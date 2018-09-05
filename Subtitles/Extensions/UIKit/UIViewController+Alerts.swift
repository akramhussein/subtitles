//
//  UIViewController+Alerts.swift
//  AHUtils
//
//  Created by Akram Hussein on 08/23/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.
//

import UIKit

public extension UIViewController {
    func showAlert(_ message: String, okTitle: String? = "OK", okPressed: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: okTitle, style: .default) { _ in
            okPressed?()
        }
        alertController.addAction(actionOk)
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(alertController, animated: true, completion: nil)
        })
    }
}
