//
//  File.swift
//  
//
//  Created by Florian Zand on 20.09.22.
//

#if os(macOS)
import Foundation
import AppKit

public extension NSColor {
    static var label: NSColor {
        return NSColor.labelColor
    }
}

#endif

#if canImport(UIKit)
import UIKit
public extension UIColor {
    static var shadowColor: UIColor {
        return UIColor.black
    }
}
public extension CGColor {
    static var clear: CGColor {
        return UIColor.clear.cgColor
    }
}
#endif
