//
//  UILabel+Additions.swift
//  AHUtils
//
//  Created by Akram Hussein on 08/23/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.
//

import UIKit

public extension UILabel {
    var fontSize: CGFloat {
        if adjustsFontSizeToFitWidth {
            self.sizeToFit()
            var currentFont: UIFont = self.font
            let originalFontSize = currentFont.pointSize
            var currentSize: CGSize = (self.text! as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])

            while currentSize.width > self.frame.size.width && currentFont.pointSize > (originalFontSize * minimumScaleFactor) {
                currentFont = currentFont.withSize(currentFont.pointSize - 1)
                currentSize = (text! as NSString).size(withAttributes: [NSAttributedStringKey.font: currentFont])
            }

            return currentFont.pointSize
        }

        return font.pointSize
    }
}
