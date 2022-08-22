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
    var visibleWindows: [NSWindow] {
        return self.windows.filter({
            $0.isVisible && $0.isOnActiveSpace && !$0.isFloatingPanel })
    }
}

#endif
