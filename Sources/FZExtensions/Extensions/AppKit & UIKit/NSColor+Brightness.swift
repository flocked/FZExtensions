//
//  File.swift
//  
//
//  Created by Florian Zand on 06.10.22.
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension NSUIColor {
    func tinted(amount: CGFloat = 0.2)-> NSUIColor? {
        return self.blended(withFraction: amount, of: .white)
    }
    
    func shaded(amount: CGFloat = 0.2)-> NSUIColor? {
        return self.blended(withFraction: amount, of: .black)
    }
    
    func lighter() -> NSUIColor {
        return withBrightness(1.25)
    }
    
    func darkened() -> NSUIColor {
        return withBrightness(0.75)
    }
    
    func withBrightness(_ amount: CGFloat) -> NSUIColor {
        let hsii = hsl
        return NSUIColor(hue: hsii.hue, saturation: hsii.saturation, lightness: hsii.lightness * amount, alpha: hsii.alpha)
    }
    
    internal convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1)  {
         let offset = saturation * (lightness < 0.5 ? lightness : 1 - lightness)
         let brightness = lightness + offset
         let saturation = lightness > 0 ? 2 * offset / brightness : 0
         self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
     }
        
   internal var hsl: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0, hue: CGFloat = 0
       #if os(macOS)
       let main = self.usingColorSpace(.deviceRGB)!
       #else
       let main = self
       #endif
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
