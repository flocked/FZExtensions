//
//  File.swift
//  
//
//  Created by Florian Zand on 24.09.22.
//

import SwiftUI

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension Font {
    init(_ font: NSUIFont) {
        self = Font(font as CTFont)
    }
}

public extension NSUIFont {
    static var caption2: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .caption2)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize - 6)
    }
    
    static var caption: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .caption1)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize - 5)
    }
    
    static var footnote: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .footnote)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize - 4)
    }
    
    static var callout: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .callout)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize - 1)
    }
    
    static var body: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .body)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize)
    }
    
    static var subheadline: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .subheadline)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize - 2)
    }
    
    static var headline: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .headline)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize - 2, weight: .semibold)
    }
    
    static var title3: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .title3)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize + 3)
    }
    
    static var title2: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .title2)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize + 5)
    }
    
    static var title: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .title1)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize + 11)
    }
    
    static var largeTitle: NSUIFont {
        if #available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *) {
            return .preferredFont(forTextStyle: .largeTitle)
        }
        return .systemFont(ofSize: NSUIFont.systemFontSize + 17)
    }
    
    static func monospaced() -> NSUIFont {
#if os(macOS)
        .monospacedSystemFont(ofSize: NSUIFont.systemFontSize, weight: .regular)
#else
        .system(.body, design: .monospaced)
#endif
    }
}

public extension NSUIFont {
    static func system(size: CGFloat, weight: NSUIFont.Weight, design: NSUIFontDescriptor.SystemDesign = .default) -> NSUIFont {
        let descriptor = NSUIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(design)!
#if os(macOS)
        return NSUIFont(descriptor: descriptor, size: size)!
#else
        return NSUIFont(descriptor: descriptor, size: size)
#endif
    }
    
    @available(macOS 11.0, iOS 12.2, tvOS 12.2, watchOS 5.2, *)
    static func system(_ style: NSUIFont.TextStyle, design: NSUIFontDescriptor.SystemDesign = .default) -> NSUIFont {
        let descriptor = NSUIFontDescriptor.preferredFontDescriptor(forTextStyle: style).withDesign(design)!
#if os(macOS)
        return NSUIFont(descriptor: descriptor, size: 0)!
#else
        return NSUIFont(descriptor: descriptor, size: 0)
#endif
    }
    
    func weight(_ weight: NSUIFont.Weight) -> NSUIFont {
        addingAttributes([
            NSUIFontDescriptor.AttributeName.traits: [
                NSUIFontDescriptor.TraitKey.weight: weight.rawValue
            ]
        ])
    }
    
    func italic() -> NSUIFont {
#if os(macOS)
        self.symbolicTraits(.italic)
#else
        self.symbolicTraits(.traitItalic)
#endif
    }
    
    func bold() -> NSUIFont {
#if os(macOS)
        self.symbolicTraits(.bold)
#else
        self.symbolicTraits(.traitBold)
#endif
    }
    
    func symbolicTraits(_ symbolicTraits: NSUIFontDescriptor.SymbolicTraits) -> NSUIFont {
        var descriptor = fontDescriptor.withSymbolicTraits(symbolicTraits)
#if os(macOS)
        return NSUIFont(descriptor: descriptor, size: 0)!
#else
        return NSUIFont(descriptor: descriptor, size: 0)
#endif
    }
    
    func leading(_ leading: Leading) -> NSUIFont {
#if os(macOS)
        self.symbolicTraits(leading == .loose ? .looseLeading : .tightLeading)
#else
        self.symbolicTraits(leading == .loose ? .traitLooseLeading : .traitTightLeading)
#endif
    }
    
    enum Leading {
        case loose
        case tight
    }
    
    internal func addingAttributes(_ attributes: [NSUIFontDescriptor.AttributeName: Any]) -> NSUIFont {
        let font = NSUIFont(descriptor: fontDescriptor.addingAttributes(attributes), size: pointSize)
#if os(macOS)
        return font!
#else
        return font
#endif
    }
    
}

@available(macOS 11.0, *)
extension NSUIFont.TextStyle {
    internal var swiftUI: Font.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title1: return .title
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption1: return .caption
        case .caption2: return .caption2
        default:
            return .body
        }
    }
}

/*
 public extension Font {
 func weight(ui weight: NSUIFont.Weight) -> Font {
 switch weight {
 case .ultraLight: return self.weight(.ultraLight)
 case .thin: return self.weight(.thin)
 case .light: return self.weight(.light)
 case .regular: return self.weight(.regular)
 case .medium: return self.weight(.medium)
 case .heavy: return self.weight(.heavy)
 case .semibold: return self.weight(.semibold)
 case .bold: return self.weight(.bold)
 case .black: return self.weight(.black)
 default:
 return self
 }
 }
 }
 */
