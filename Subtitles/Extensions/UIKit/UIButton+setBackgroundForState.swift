//
//  UIButton+setBackgroundForState.swift
//  AHUtils
//
//  Created by Akram Hussein on 08/23/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.
//

import Foundation
import UIKit

public extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))

        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))

        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(colorImage, for: forState)
    }
}
