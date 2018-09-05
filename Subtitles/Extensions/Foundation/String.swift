//
//  String.swift
//  AHUtils
//
//  Created by Akram Hussein on 08/23/2017.
//  Copyright (c) 2017 Akram Hussein. All rights reserved.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    subscript(i: Int) -> String {
        return String(Array(arrayLiteral: self)[i])
    }

    func location(_ other: String) -> Int {
        return (self as NSString).range(of: other).location
    }

    var isNumeric: Bool {
        return (self as NSString).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted).location == NSNotFound
    }

    func removeWords(_ words: [String]) -> String {
        var cleanedString = self

        // Remove common words
        for word in words {
            cleanedString = cleanedString.replacingOccurrences(of: word, with: "", options: NSString.CompareOptions.literal, range: nil)
        }

        // strip newlines and spaces
        cleanedString = cleanedString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        return cleanedString
    }

    func replace(_ string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    var removeWhitespace: String {
        return self.replace(" ", replacement: "")
    }

    public func contains(_ other: String) -> Bool {
        // rangeOfString returns nil if other is empty, destroying the analogy with (ordered) sets.
        if other.isEmpty {
            return true
        }
        return self.range(of: other) != nil
    }

    public func startsWith(_ other: String) -> Bool {
        // rangeOfString returns nil if other is empty, destroying the analogy with (ordered) sets.
        if other.isEmpty {
            return true
        }
        if let range = self.range(of: other, options: NSString.CompareOptions.anchored) {
            return range.lowerBound == self.startIndex
        }
        return false
    }

    public func endsWith(_ other: String) -> Bool {
        // rangeOfString returns nil if other is empty, destroying the analogy with (ordered) sets.
        if other.isEmpty {
            return true
        }
        if let range = self.range(of: other, options: [NSString.CompareOptions.anchored, NSString.CompareOptions.backwards]) {
            return range.upperBound == self.endIndex
        }
        return false
    }

    fileprivate var stringWithAdditionalEscaping: String {
        return self.replacingOccurrences(of: "|", with: "%7C", options: NSString.CompareOptions(), range: nil)
    }

    public var asURL: URL? {
        return URL(string: self) ?? URL(string: self.stringWithAdditionalEscaping)
    }

    /// Returns a new string made by removing the leading String characters contained
    /// in a given character set.
    public func stringByTrimmingLeadingCharactersInSet(_ set: CharacterSet) -> String {
        var trimmed = self
        while trimmed.rangeOfCharacter(from: set)?.lowerBound == trimmed.startIndex {
            trimmed.remove(at: trimmed.startIndex)
        }
        return trimmed
    }

    public func containsIgnoringCase(find: String) -> Bool {
        return (self.range(of: find, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil)
    }
    
    public var uppercaseFirst: String {
        return self[0].uppercased() + String(self.dropFirst())
    }
    
    var capitalizingFirstLetter: String {
        let first = self.prefix(1).capitalized
        let other = self.dropFirst()
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter
    }
}
