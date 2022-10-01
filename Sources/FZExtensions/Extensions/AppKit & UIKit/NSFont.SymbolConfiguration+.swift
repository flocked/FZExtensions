//
//  File.swift
//  
//
//  Created by Florian Zand on 01.10.22.
//

#if os(macOS)
import AppKit
import SwiftUI

@available(macOS 11.0, *)
extension NSUIFont.TextStyle: CaseIterable {
    public static var allCases: [Self] {
        [.body, .subheadline, .headline, .caption1, .caption2, .callout, .footnote, .title1, .title2, .title3, .largeTitle]
    }
}


@available(macOS 12.0, *)
internal extension NSImage.SymbolConfiguration {
     struct Modifier: ImageModifier {
        let configuration: NSImage.SymbolConfiguration
        func body(image: SwiftUI.Image) -> some View {
           return image.symbolRenderingMode(configuration.mode?.symbolRendering)
                .font(configuration.font)
                .if(configuration.scale != nil, transform: {$0.imageScale(configuration.scale!.swiftUI)})
        }
    }
    
    var colors: [NSColor] {
        (self.value(forKey: "paletteColors") as? [NSColor]) ?? []
    }
    
    enum Mode: String {
        case monochrome
        case multicolor
        case hierarchical
        case palette
        var symbolRendering: SymbolRenderingMode {
            switch self {
            case .monochrome:   return .monochrome
            case .multicolor: return .multicolor
            case .hierarchical: return .hierarchical
            case .palette:  return .palette
            }
        }
    }
    
    var mode: Mode? {
        if self.colors.isEmpty == false, let type = self.value(forKey: "paletteType") as? Int {
            if (type == 1) {
                return .hierarchical
            } else if (type == 2) {
                if (prefersMulticolor) {
                    return .multicolor
                } else {
                    return .palette
                }
            }
        }
        return nil
    }
    
    var scale: NSImage.SymbolScale? {
        if let value = self.value(forKey: "scale") as? Int {
           return NSImage.SymbolScale(rawValue: value)
        }
        return nil
    }
    var weight: NSFont.Weight? {
        if let weight = self.value(forKey: "weight") as? CGFloat {
            Swift.print(weight)
            return NSFont.Weight(rawValue: weight)
        }
        return nil
    }
    var font: Font? {
        if let pointSize = pointSize {
            if let weight = weight?.swiftUI {
                return Font.system(size: pointSize, weight: weight)
            }
            return Font.system(size: pointSize)
        }
        return nil
    }
    
    var prefersMulticolor: Bool {
        (self.value(forKey: "prefersMulticolor") as? Bool) ?? false
    }
    
    var pointSize: CGFloat? {
        self.value(forKey: "pointSize") as? CGFloat
    }
}

@available(macOS 11.0, *)
extension NSUIImage.SymbolScale {
    internal var swiftUI: Image.Scale {
        switch self {
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        @unknown default: return .small
        }
    }
}
extension NSUIFont.Weight {
    internal var swiftUI: Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .heavy: return .heavy
        case .semibold: return .semibold
        case .bold: return .bold
        case .black: return .black
        default: return .regular
        }
    }
}
#endif
