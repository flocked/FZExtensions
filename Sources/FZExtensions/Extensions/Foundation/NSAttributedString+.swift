//
//  File.swift
//  
//
//  Created by Florian Zand on 03.09.22.
//

import Foundation

public extension NSAttributedString {
    func lowercased() -> NSAttributedString {
        let range = NSRange(location: 0, length: self.length)
        let value = NSMutableAttributedString(attributedString: self)
        let string = value.string.lowercased()
        value.replaceCharacters(in: range, with: string)
        return value.attributedSubstring(from: range)
    }
    
    func uppercased() -> NSAttributedString {
        let range = NSRange(location: 0, length: self.length)
        let value = NSMutableAttributedString(attributedString: self)
        let string = value.string.uppercased()
        value.replaceCharacters(in: range, with: string)
        return value.attributedSubstring(from: range)
    }
    
    func capitalized() -> NSAttributedString {
        let range = NSRange(location: 0, length: self.length)
        let value = NSMutableAttributedString(attributedString: self)
        let string = value.string.capitalized
        value.replaceCharacters(in: range, with: string)
        return value.attributedSubstring(from: range)
    }
}
