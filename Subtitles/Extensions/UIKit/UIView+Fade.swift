//
//  UIView+Fade.swift
//  AHUtils
//
//  Created by Akram Hussein on 08/23/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    func fadeOut(_ duration: TimeInterval, hide: Bool = false) {
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.alpha = 0
        }, completion: { (_) -> Void in
            if hide {
                self.isHidden = true
            }
        })
    }

    func fadeOutWithCompletion(_ duration: TimeInterval, hide: Bool = false, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.alpha = 0
        }, completion: { (done) -> Void in
            if hide {
                self.isHidden = true
            }
            completion(done)
        })
    }

    func fadeIn(_ duration: TimeInterval, to: CGFloat = 1.0) {
        self.isHidden = false
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.alpha = to
        })
    }

    func fadeInWithCompletion(_ duration: TimeInterval, completion: @escaping (Bool) -> Void) {
        self.isHidden = false
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.alpha = 1
        }, completion: { (done) -> Void in
            completion(done)
        })
    }
}
