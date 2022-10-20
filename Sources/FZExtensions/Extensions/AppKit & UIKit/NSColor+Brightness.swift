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
    func tinted(by amount: CGFloat = 0.2)-> NSUIColor {
        #if os(macOS)
        return self.blended(withFraction: amount, of: .white) ?? self
        #else
        return self.blended(withFraction: amount, of: .white)
        #endif
    }
    
    func shaded(by amount: CGFloat = 0.2)-> NSUIColor {
#if os(macOS)
        return self.blended(withFraction: amount, of: .black) ?? self
#else
        return self.blended(withFraction: amount, of: .black)
#endif
    }
    
    func lighter(by amount: CGFloat = 0.2) -> NSUIColor {
        return HSL(color: self).lighter(amount: amount).toColor()
    }
    
    func darkened(by amount: CGFloat = 0.2) -> NSUIColor {
        return HSL(color: self).darkened(amount: amount).toColor()
    }
    
    final func saturated(amount: CGFloat = 0.2) -> NSUIColor {
      return HSL(color: self).saturated(amount: amount).toColor()
    }

    final func desaturated(amount: CGFloat = 0.2) -> NSUIColor {
      return HSL(color: self).desaturated(amount: amount).toColor()
    }
    
    final func grayscaled(mode: GrayscalingMode = .lightness) -> NSUIColor {
      let (r, g, b, a) = self.rgbaComponents()

      let l: CGFloat
      switch mode {
      case .luminance:
        l = (0.299 * r) + (0.587 * g) + (0.114 * b)
      case .lightness:
        l = 0.5 * (max(r, g, b) + min(r, g, b))
      case .average:
        l = (1.0 / 3.0) * (r + g + b)
      case .value:
        l = max(r, g, b)
      }

      return HSL(hue: 0.0, saturation: 0.0, lightness: l, alpha: a).toColor()
    }
    
    func withBrightness(_ amount: CGFloat) -> NSUIColor {
        let hsii = hsl
        return NSUIColor(hue: hsii.hue, saturation: hsii.saturation, lightness: hsii.lightness * amount, alpha: hsii.alpha)
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

public enum GrayscalingMode {
  case luminance
  case lightness
  case average
  case value
}
