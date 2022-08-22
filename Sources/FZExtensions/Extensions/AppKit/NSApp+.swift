//
//  NSApp+.swift
//  FZExtensions
//
//  Created by Florian Zand on 14.07.22.
//

#if os(macOS)

import Foundation
import AppKit

extension NSApplication {
    var windowsOnActiveSpace: [NSWindow] {
        self.windows.filter({$0.isOnActiveSpace})
    }
}

#endif
