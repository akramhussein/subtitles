//
//  Theme.swift
//  Subtitles
//
//  Created by Akram Hussein on 02/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import UIKit
import Material

struct Theme {

    static var statusBar: UIView? {
        return (UIApplication.shared.value(forKey: "statusBarWindow") as AnyObject).value(forKey: "statusBar") as? UIView
    }

    static func apply(statusBarColor: UIColor) {
        UIBarButtonItem.appearance().tintColor = .white

        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().isOpaque = true
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Color.red.base
        ]

        UINavigationBar.appearance().setBackgroundImage(UIImage(),
                                                        for: .any,
                                                        barMetrics: .default)

        UINavigationBar.appearance().shadowImage = UIImage()

        self.statusBar?.backgroundColor = statusBarColor
    }
}
