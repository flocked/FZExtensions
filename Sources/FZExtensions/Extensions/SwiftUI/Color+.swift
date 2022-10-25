//
//  File.swift
//  
//
//  Created by Florian Zand on 06.10.22.
//

import SwiftUI

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension NSUIColor {
    var swiftUI: Color {
        return Color(self)
    }
}


public extension Color {
    @available(macOS 11.0, iOS 14.0, *)
    init(light lightModeColor: @escaping @autoclosure () -> Color,
        dark darkModeColor: @escaping @autoclosure () -> Color) {
        self.init(NSUIColor(
            light: NSUIColor(lightModeColor()),
            dark: NSUIColor(darkModeColor())))
    }
}

@available(macOS 11.0, iOS 14.0, *)
public extension Color {
    var secondary: Color {
        self.opacity(0.15)
    }
    
    static func random() -> Color {
       return Color (NSUIColor.random())
    }
    
    func mixed(with color: Color, by amount: CGFloat = 0.5) -> Color {
        let amount = amount.clamped(0.0...1.0)
        let nsUIColor = NSUIColor(self)
        return Color(nsUIColor.mixed(with: NSUIColor(color) , by: amount))
    }
    
    func lighter(by amount: CGFloat = 0.2) -> Color {
        let amount = amount.clamped(0.0...1.0)
        return brightness(1.0+amount)
    }
    
    func darkened(by amount: CGFloat = 0.2) -> Color {
        let amount = amount.clamped(0.0...1.0)
        return brightness(1.0-amount)
    }
    
    func brightness(_ amount: CGFloat) -> Color {
        var amount = amount
        if (amount > 1.0) {
            amount = amount - 1.0
            return self.mixed(with: .white, by: amount)
        } else if (amount < 1.0) {
            amount = amount.clamped(0.0...1.0)
            amount = 1.0 - amount
            return self.mixed(with: .black, by: amount)
        }
        return self
    }
}
