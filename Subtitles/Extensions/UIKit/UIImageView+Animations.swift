//
//  UIImage+Animations.swift
//  AHUtils
//
//  Created by Akram Hussein on 08/23/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.
//

import UIKit

public extension UIImageView {
    func pop() {
        let expandTransform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.transform = expandTransform
        UIView.animate(withDuration: 0.4,
                       delay: 0.0,
                       usingSpringWithDamping: 0.40,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut,
                       animations: {
                           self.transform = expandTransform.inverted()
                       },
                       completion: nil)
    }
}
