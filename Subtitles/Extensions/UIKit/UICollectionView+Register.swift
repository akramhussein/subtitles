//
//  UICollectionView+Register.swift
//  Pods
//
//  Created by Akram Hussein on 24/08/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.
//

import UIKit
import Foundation

public extension UICollectionView {

    func registerCell(className: String, bundle: Bundle? = nil) {
        self.register(UINib(nibName: className, bundle: bundle),
                      forCellWithReuseIdentifier: className)
    }
    
    func registerCells(classNames: [String], bundle: Bundle? = nil) {
        classNames.forEach {
            self.register(UINib(nibName: $0, bundle: bundle),
                          forCellWithReuseIdentifier: $0)
        }
    }

    func registerFooter(className: String, bundle: Bundle? = nil) {
        self.register(UINib(nibName: className, bundle: bundle),
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                      withReuseIdentifier: className)
    }

    func registerHeader(className: String, bundle: Bundle? = nil) {
        self.register(UINib(nibName: className, bundle: bundle),
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: className)
    }

}
