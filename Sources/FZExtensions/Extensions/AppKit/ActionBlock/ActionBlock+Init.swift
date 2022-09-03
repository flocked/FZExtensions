//
//  ActionBlock+Init.swift
//  CombTest
//
//  Created by Florian Zand on 30.05.22.
//

#if os(macOS)

import Foundation
import AppKit

fileprivate let TargetActionProtocolAssociatedObjectKey = UnsafeMutablePointer<Int8>.allocate(capacity: 1)

public extension NSMenuItem {
    convenience init(_ title: String, state: NSControl.StateValue = .off, image: NSImage? = nil, action: @escaping ActionBlock) {
        self.init(title: title, action: action)
        self.state = state
        self.image = image
    }
    
    convenience init(title: String, action: @escaping ActionBlock) {
        self.init(title: title, keyEquivalent: "", action: action)
    }
    
    convenience init(title: String, keyEquivalent: String, action: @escaping ActionBlock) {
        self.init(title: title, action: nil, keyEquivalent: keyEquivalent)
        self.actionBlock = action
    }
}

public extension NSMenu {
    convenience init(items: [NSMenuItem], action: @escaping NSMenuItem.ActionBlock) {
        self.init(items: items)
        for i in 0...items.count-1 {
            self.items[i].actionBlock = action
        }
    }
}

public extension NSMagnificationGestureRecognizer {
    convenience init(action: @escaping ActionBlock) {
        self.init()
        self.actionBlock = action
    }
}

public extension NSRotationGestureRecognizer {
    convenience init(action: @escaping ActionBlock) {
        self.init()
        self.actionBlock = action
    }
}

public extension NSClickGestureRecognizer {
    convenience init(action: @escaping ActionBlock) {
        self.init()
        self.actionBlock = action
    }
}

public extension NSPanGestureRecognizer {
    convenience init(action: @escaping ActionBlock) {
        self.init()
        self.actionBlock = action
    }
}

public extension NSPressGestureRecognizer {
    convenience init(action: @escaping ActionBlock) {
        self.init()
        self.actionBlock = action
    }
}

#endif
