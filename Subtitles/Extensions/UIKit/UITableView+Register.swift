//
//  UILabel+Register.swift
//  AHUtils
//
//  Created by Akram Hussein on 08/23/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.
//

import UIKit

public extension UITableView {

    func registerCell(className: String, bundle: Bundle? = nil) {
        self.register(UINib(nibName: className, bundle: bundle),
                      forCellReuseIdentifier: className)
    }

    func registerCells(classNames: [String], bundle: Bundle? = nil) {
        for className in classNames {
            self.registerCell(className: className, bundle: bundle)
        }
    }

    func registerHeaderFooterViews(classNames: [String], bundle: Bundle? = nil) {
        for className in classNames {
            let nib = UINib(nibName: className, bundle: bundle)
            self.register(nib, forHeaderFooterViewReuseIdentifier: className)
        }
    }
}
