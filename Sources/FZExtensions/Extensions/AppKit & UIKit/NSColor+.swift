//
//  File.swift
//  
//
//  Created by Florian Zand on 20.09.22.
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if os(macOS)
public extension NSColor {
    static var label: NSColor {
        return NSColor.labelColor
    }
}
#endif

#if canImport(UIKit)
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

public extension UIColor {
    func blended(withFraction: CGFloat, of color: UIColor) -> UIColor {
        return NSUIColor.interpolate(from: self, to: color, with: withFraction)
    }
}
#endif
