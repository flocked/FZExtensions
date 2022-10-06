//
//  File.swift
//  
//
//  Created by Florian Zand on 26.08.22.
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension NSUIColor {
    func mixed(with color: NSUIColor, by amount: CGFloat = 0.5) -> NSUIColor {
        return NSUIColor.interpolate(from: self, to: color, with: amount)
    }
    
    static func interpolate(from fromColor: NSUIColor, to toColor: NSUIColor, with progress: CGFloat) -> NSUIColor {
        let progress = min(1.0, max(progress, 0.0))

        let fromComponents = fromColor.components
        let toComponents = toColor.components

        let r = (1 - progress) * fromComponents.r + progress * toComponents.r
        let g = (1 - progress) * fromComponents.g + progress * toComponents.g
        let b = (1 - progress) * fromComponents.b + progress * toComponents.b
        let a = (1 - progress) * fromComponents.a + progress * toComponents.a

        return NSUIColor(red: r, green: g, blue: b, alpha: a)
    }

    /// The RGBA components associated with a `UIColor` instance.
   internal var components: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let components = self.cgColor.components!
        if components.count == 2 {
            return (r: components[0], g: components[0], b: components[0], a: components[1])
        } else {
            return (r: components[0], g: components[1], b: components[2], a: components[3])
        }
    }
}
