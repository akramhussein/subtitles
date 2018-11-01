//
//  NSMutableAttributedString+Sizing.swift
//  AHUtils
//
//  Created by Akram Hussein on 08/23/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.
//

import Foundation
import UIKit

public extension NSMutableAttributedString {
    /** Makes an attributes string with the specified (plain) string and font but resizes the font smaller
     to fit the width if required. Can return nil, if there is no way to make it fit */
    convenience init?(string: String, font: UIFont, maxWidth: CGFloat, color: UIColor) {
        self.init()

        var size = font.pointSize
        while size > 1 {
            let attrs = [
                NSAttributedString.Key.font: font.withSize(size),
                NSAttributedString.Key.foregroundColor: color
            ]
            let attrString = NSAttributedString(string: string, attributes: attrs)
            if attrString.size().width <= maxWidth {
                self.setAttributedString(attrString)
                return
            }
            size -= 1
        }
        return nil
    }

}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

public func += (left: inout NSMutableAttributedString, right: NSAttributedString) {
    left.append(right)
}

public func + (left: inout NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString(attributedString: right)
    result.append(right)
    return result
}

public func + (left: NSAttributedString, right: String) -> NSAttributedString {
    let result = NSMutableAttributedString(attributedString: left)
    result.append(NSAttributedString(string: right))
    return result
}
