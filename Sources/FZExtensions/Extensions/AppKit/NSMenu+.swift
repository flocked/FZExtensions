//
//  NSMenu+.swift
//  FZExtensions
//
//  Created by Florian Zand on 06.06.22.
//

#if os(macOS)

import Foundation
import AppKit

public extension NSMenu {
    convenience init(items: [NSMenuItem]) {
        self.init()
        for item in items {
            self.addItem(item)
        }
    }
    
    convenience init(titles: [String]) {
        self.init()
        for title in titles {
            self.addItem(NSMenuItem(title))
        }
    }
}

public extension NSMenuItem {
    convenience init(_ title: String) {
        self.init(title: title)
    }
    
    convenience init(title: String) {
        self.init(title: title, action: nil, keyEquivalent: "")
        self.isEnabled = true
    }
    
    convenience init(_ title: String, action: Selector) {
        self.init(title: title, action: action)
    }
    
    convenience init(title: String, action: Selector) {
        self.init(title: title, action: action, keyEquivalent: "")
        self.isEnabled = true
    }
    
}


#endif
