//
//  UIView.swift
//  Subtitles
//
//  Created by Akram Hussein on 09/12/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import UIKit

public extension UIView {

    public func layoutAttachAll(to parentView: UIView) {
        var constraints = [NSLayoutConstraint]()
        self.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1.0, constant: 0))
        parentView.addConstraints(constraints)
    }

    public func addSubviewAndAttach(subview: UIView, clipsToBounds: Bool = true) {
        self.addSubview(subview)
        subview.layoutAttachAll(to: self)
        self.clipsToBounds = true
    }

    func removeConstraints() {
        self.removeConstraints(constraints)
    }

    func deactivateAllConstraints() {
        NSLayoutConstraint.deactivate(self.getAllConstraints())
    }

    func getAllSubviews() -> [UIView] {
        return UIView.getAllSubviews(view: self)
    }

    func getAllConstraints() -> [NSLayoutConstraint] {

        var subviewsConstraints = getAllSubviews().flatMap { (view) -> [NSLayoutConstraint] in
            return view.constraints
        }

        if let superview = self.superview {
            subviewsConstraints += superview.constraints.compactMap { (constraint) -> NSLayoutConstraint? in
                if let view = constraint.firstItem as? UIView {
                    if view == self {
                        return constraint
                    }
                }
                return nil
            }
        }

        return subviewsConstraints + constraints
    }

    class func getAllSubviews(view: UIView) -> [UIView] {
        return view.subviews.flatMap { subView -> [UIView] in
            [subView] + getAllSubviews(view: subView)
        }
    }
}
