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

public extension NSColor {
    convenience init(name: NSColor.Name? = nil,
        light lightModeColor: @escaping @autoclosure () -> NSColor,
        dark darkModeColor: @escaping @autoclosure () -> NSColor
     ) {
        self.init(name: name, dynamicProvider: { appereance in
            if (appereance.name == .vibrantLight || appereance.name == .aqua) {
                return lightModeColor()
            } else {
                return darkModeColor()
            }
        })
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

public extension UIColor {
    convenience init(
        light lightModeColor: @escaping @autoclosure () -> UIColor,
        dark darkModeColor: @escaping @autoclosure () -> UIColor
     ) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return lightModeColor()
            case .dark:
                return darkModeColor()
            case .unspecified:
                return lightModeColor()
            @unknown default:
                return lightModeColor()
            }
        }
    }
}
#endif
