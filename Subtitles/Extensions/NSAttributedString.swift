//
//  NSAttributedString.swift
//  Subtitles
//
//  Created by Akram Hussein on 31/08/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import Foundation

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
