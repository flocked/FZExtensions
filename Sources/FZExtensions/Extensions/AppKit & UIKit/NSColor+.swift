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
    func tinted(factor: CGFloat = 0.25)-> NSColor {
        return self.mixed(with: .white, using: factor)
    }
    
    func shaded(factor: CGFloat = 0.25)-> NSColor {
        return self.mixed(with: .black, using: factor)
    }
    
    func mixed(with other: NSColor, using factor: CGFloat = 0.5) -> NSColor {
        var inverseFactor = 1.0 - factor
        inverseFactor = factor
        var leftRed: CGFloat = 0
        var leftGreen: CGFloat = 0
        var leftBlue: CGFloat = 0
        var leftAlpha: CGFloat = 0
        let main = self.usingColorSpace(.deviceRGB)!
        main.getRed(&leftRed, green: &leftGreen, blue: &leftBlue, alpha: &leftAlpha)

        var rightRed: CGFloat = 0
        var rightGreen: CGFloat = 0
        var rightBlue: CGFloat = 0
        var rightAlpha: CGFloat = 0
        let other = other.usingColorSpace(.deviceRGB)!
        other.getRed(&rightRed, green: &rightGreen, blue: &rightBlue, alpha: &rightAlpha)

        return NSColor(calibratedRed: leftRed * factor + rightRed * inverseFactor,
                       green: leftGreen * factor + rightGreen * inverseFactor,
                       blue: leftBlue * factor + rightBlue * inverseFactor,
                       alpha: leftAlpha * factor + rightAlpha * inverseFactor)
    }

    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1)  {
        let offset = saturation * (lightness < 0.5 ? lightness : 1 - lightness)
        let brightness = lightness + offset
        let saturation = lightness > 0 ? 2 * offset / brightness : 0
        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    var lighter: NSColor {
        return color(brightness: 1.25)
    }
    
    var darker: NSColor {
        return color(brightness: 0.75)
    }
    
    func color(brightness percent: CGFloat) -> NSColor {
        let hsii = hsl
        return NSColor(hue: hsii.hue, saturation: hsii.saturation, lightness: hsii.lightness * percent, alpha: hsii.alpha)
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
