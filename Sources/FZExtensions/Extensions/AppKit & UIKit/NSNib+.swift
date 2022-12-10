//
//  NSMenu+.swift
//  FZExtensions
//
//  Created by Florian Zand on 06.06.22.
//

#if os(macOS)

import AppKit

public extension NSNib {
    convenience init?(nibNamed nibName: NSNib.Name) {
         self.init(nibNamed: nibName, bundle: nil)
    }
}

#endif
