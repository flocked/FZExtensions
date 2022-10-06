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
    func tinted(amount: CGFloat = 0.2)-> NSColor? {
        return self.blended(withFraction: amount, of: .white)
    }
    
    func shaded(amount: CGFloat = 0.2)-> NSColor? {
        return self.blended(withFraction: amount, of: .black)
    }
    
    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1)  {
        let offset = saturation * (lightness < 0.5 ? lightness : 1 - lightness)
        let brightness = lightness + offset
        let saturation = lightness > 0 ? 2 * offset / brightness : 0
        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    func lighter() -> NSColor {
        return withBrightness(1.25)
    }
    
    func darkened() -> NSColor {
        return withBrightness(0.75)
    }
    
    func withBrightness(_ amount: CGFloat) -> NSColor {
        let hsii = hsl
        return NSColor(hue: hsii.hue, saturation: hsii.saturation, lightness: hsii.lightness * amount, alpha: hsii.alpha)
    }
        
   internal var hsl: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0, hue: CGFloat = 0
       let main = self.usingColorSpace(.deviceRGB)!
       main.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
       main.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        let upper = max(red, green, blue)
        let lower = min(red, green, blue)
        let range = upper - lower
        let lightness = (upper + lower) / 2
        let saturation = range == 0 ? 0 : range / (lightness < 0.5 ? lightness * 2 : 2 - lightness * 2)
        return (hue, saturation, lightness, alpha)
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
