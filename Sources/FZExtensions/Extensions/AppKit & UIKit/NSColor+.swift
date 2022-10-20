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

public extension NSUIColor {
    static func random() -> NSUIColor {
        let r: CGFloat = CGFloat.random(in: 0.0...1.0)
        let g: CGFloat = CGFloat.random(in: 0.0...1.0)
        let b: CGFloat = CGFloat.random(in: 0.0...1.0)
        return NSUIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

#if os(macOS)
public extension NSColor {
    static var label: NSColor {
        return NSColor.labelColor
    }

    var dynamicColors: (light: NSColor, dark: NSColor) {
        let light = self.resolvedColor(for: .aqua)
        let dark = self.resolvedColor(for: .darkAqua)
        return (light, dark)
    }
    
    func resolvedColor(for appearance: NSAppearance? = nil) -> NSColor {
        var color = self
        if (self.type == .catalog) {
            if #available(macOS 11.0, *) {
                let appearance = appearance ?? .currentDrawing()
                appearance.performAsCurrentDrawingAppearance {
                    color = self.usingColorSpace(.sRGB) ?? self
                }
            } else {
                let appearance = appearance ?? .current
                let current = NSAppearance.current
                NSAppearance.current = appearance
                color = self.usingColorSpace(self.colorSpace) ?? self
                NSAppearance.current = current
            }
        }
        return color
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

public extension CGColor {
    func alpha(_ alpha: CGFloat) -> CGColor {
        return self.copy(alpha: alpha) ?? self
    }
}

public extension NSUIColor {
    func rgbaComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        var color: NSUIColor? = self
#if os(macOS)
        let supportedColorSpaces: [NSColorSpace] = [.sRGB, .extendedSRGB, .genericRGB, .adobeRGB1998, .deviceRGB, .displayP3]
        if (supportedColorSpaces.contains(self.colorSpace) == false) {
            color = (self.usingColorSpace(.extendedSRGB) ?? self.usingColorSpace(.genericRGB)) ?? nil
        }
#endif
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
    func hsbComponents() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
      var h: CGFloat = 0.0
      var s: CGFloat = 0.0
      var b: CGFloat = 0.0

        var color: NSUIColor? = self
      #if os(macOS)
        let supportedColorSpaces: [NSColorSpace] = [.sRGB, .extendedSRGB, .genericRGB, .adobeRGB1998, .deviceRGB, .displayP3]
        if (supportedColorSpaces.contains(self.colorSpace) == false) {
            color = (self.usingColorSpace(.extendedSRGB) ?? self.usingColorSpace(.genericRGB)) ?? nil
        }
      #endif
        color?.getHue(&h, saturation: &s, brightness: &b, alpha: nil)
        return (hue: h, saturation: s, brightness: b)
    }
    
    func hslComponents() -> (hue: CGFloat, saturation: CGFloat, lightness: CGFloat) {
        let hsl = HSL(color: self)
        return (hue: hsl.h, saturation: hsl.s, lightness: hsl.l)
    }
    
    internal var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        var color: NSUIColor? = self
#if os(macOS)
        let supportedColorSpaces: [NSColorSpace] = [.sRGB, .extendedSRGB, .genericRGB, .adobeRGB1998, .deviceRGB, .displayP3]
        if (supportedColorSpaces.contains(self.colorSpace) == false) {
            color = (self.usingColorSpace(.extendedSRGB) ?? self.usingColorSpace(.genericRGB)) ?? nil
        }
#endif
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
    internal var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        var color: NSUIColor? = self
#if os(macOS)
        let supportedColorSpaces: [NSColorSpace] = [.sRGB, .extendedSRGB, .genericRGB, .adobeRGB1998, .deviceRGB, .displayP3]
        if (supportedColorSpaces.contains(self.colorSpace) == false) {
            color = (self.usingColorSpace(.extendedSRGB) ?? self.usingColorSpace(.genericRGB)) ?? nil
        }
#endif
        color?.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue, saturation, brightness, alpha)
    }
    
    var redComponent: CGFloat {
        get { self.rgba.red }
    }
    
    var greenComponent: CGFloat {
        get { self.rgba.green }
    }
    
    var blueComponent: CGFloat {
        get { self.rgba.blue }
    }
    
    var alphaComponent: CGFloat {
        get { self.rgba.alpha }
    }
    
    func withRedCompoent(_ red: CGFloat) -> NSUIColor {
        let rgba = self.rgba
        return NSUIColor(red: red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }
    
    func withGreenCompoent(_ green: CGFloat) -> NSUIColor {
        let rgba = self.rgba
        return NSUIColor(red: rgba.red, green: green, blue: rgba.blue, alpha: rgba.alpha)
    }
    
    func withBlueCompoent(_ blue: CGFloat) -> NSUIColor {
        let rgba = self.rgba
        return NSUIColor(red: rgba.red, green: rgba.green, blue: blue, alpha: rgba.alpha)
    }
    
    func withSaturation(_ saturation: CGFloat) -> NSUIColor {
        let hsba = self.hsba
        return NSUIColor(hue: hsba.hue, saturation: hsba.saturation, brightness: saturation, alpha: hsba.alpha)
    }
    
    func withHue(_ hue: CGFloat) -> NSUIColor {
        let hsba = self.hsba
        return NSUIColor(hue: hue, saturation: hsba.saturation, brightness: hsba.brightness, alpha: hsba.alpha)
    }
    
}
