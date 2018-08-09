//
//  Dictionary.swift
//  Subtitles
//
//  Created by Akram Hussein on 07/01/2018.
//  Copyright © 2018 Akram Hussein. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {
    func keysForValue(value: Value) -> [Key] {
        return flatMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}
