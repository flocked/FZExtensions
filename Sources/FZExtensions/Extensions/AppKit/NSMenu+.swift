//
//  NSMenu+.swift
//  FZExtensions
//
//  Created by Florian Zand on 06.06.22.
//

#if os(macOS)

import Foundation
import AppKit

extension NSMenu {
    convenience init(items: [NSMenuItem]) {
        self.init()
        for item in items {
            self.addItem(item)
        }
    }
}

#endif
