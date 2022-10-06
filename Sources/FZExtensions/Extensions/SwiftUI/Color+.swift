//
//  File.swift
//  
//
//  Created by Florian Zand on 06.10.22.
//

import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
public extension Color {
    var secondary: Color {
        self.opacity(0.15)
    }
    
    func blended(with color: Color, by amount: CGFloat = 0.5) -> Color {
        let amount = amount.clamped(0.0...1.0)
        let nsUIColor = NSUIColor(self)
#if os(macOS)
            return Color(nsUIColor.blended(withFraction: amount, of: NSUIColor(color)) ?? nsUIColor)
#else
           return Color(nsColor.blended(withFraction: fraction, of: NSUIColor(color)))
#endif
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
            return self.blended(with: .white, by: amount)
        } else if (amount < 1.0) {
            amount = amount.clamped(0.0...1.0)
            amount = 1.0 - amount
            return self.blended(with: .black, by: amount)
        }
        return self
    }
}
