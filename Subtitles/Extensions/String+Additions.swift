//
//  String+Additions.swift
//  Subtitles
//
//  Created by Akram Hussein on 06/08/2017.
//  Copyright © 2017 Akram Hussein. All rights reserved.
//

import Foundation

extension String {

    var capitalizingFirstLetter: String {
        let first = self.prefix(1).capitalized
        let other = self.dropFirst()
        return first + other
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter
    }

    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
