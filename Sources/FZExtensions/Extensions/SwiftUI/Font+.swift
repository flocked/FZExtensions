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
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize - 6)
        #else
        .preferredFont(forTextStyle: .caption2)
        #endif
    }

    static var caption: NSUIFont {
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize - 5)
        #else
        .preferredFont(forTextStyle: .caption1)
        #endif
    }

    static var footnote: NSUIFont {
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize - 4)
        #else
        .preferredFont(forTextStyle: .footnote)
        #endif
    }

    static var callout: NSUIFont {
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize - 1)
        #else
        .preferredFont(forTextStyle: .callout)
        #endif
    }

    static var body: NSUIFont {
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize)
        #else
        .preferredFont(forTextStyle: .body)
        #endif
    }

    static var subheadline: NSUIFont {
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize - 2)
        #else
        .preferredFont(forTextStyle: .subheadline)
        #endif
    }

    static var headline: NSUIFont {
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize, weight: .semibold)
        #else
        .preferredFont(forTextStyle: .headline)
        #endif
    }

    static var title3: NSUIFont {
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize + 3)
        #else
        .preferredFont(forTextStyle: .title3)
        #endif
    }

    static var title2: NSUIFont {
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize + 5)
        #else
        .preferredFont(forTextStyle: .title2)
        #endif
    }

    static var title: NSUIFont {
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize + 11)
        #else
        .preferredFont(forTextStyle: .title1)
        #endif
    }

    static var largeTitle: NSUIFont {
        #if os(macOS)
        .systemFont(ofSize: NSUIFont.systemFontSize + 17)
        #else
        .preferredFont(forTextStyle: .largeTitle)
        #endif
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

    enum Leading {
        case loose
        case tight
    }

    private func addingAttributes(_ attributes: [NSUIFontDescriptor.AttributeName: Any]) -> NSUIFont {
        let font = NSUIFont(descriptor: fontDescriptor.addingAttributes(attributes), size: pointSize)
        #if os(macOS)
        return font!
        #else
        return font
        #endif
    }

    static func system(size: CGFloat, weight: NSUIFont.Weight, design: NSUIFontDescriptor.SystemDesign = .default) -> NSUIFont {
        let descriptor = NSUIFont.systemFont(ofSize: size).fontDescriptor
            .addingAttributes([
                NSUIFontDescriptor.AttributeName.traits: [
                    NSUIFontDescriptor.TraitKey.weight: weight.rawValue
                ]
            ]).withDesign(design)!

        let font = NSUIFont(descriptor: descriptor, size: size)
        #if os(macOS)
        return font!
        #else
        return font
        #endif
    }

    #if os(iOS)
    static func system(_ style: NSUIFont.TextStyle, design: NSUIFontDescriptor.SystemDesign = .default) -> NSUIFont {
        let descriptor = NSUIFontDescriptor.preferredNSUIFontDescriptor(withTextStyle: style).withDesign(design)!
        return NSUIFont(descriptor: descriptor, size: 0)
    }
    #endif

    func weight(_ weight: NSUIFont.Weight) -> NSUIFont {
        addingAttributes([
            NSUIFontDescriptor.AttributeName.traits: [
                NSUIFontDescriptor.TraitKey.weight: weight.rawValue
            ]
        ])
    }

    func italic() -> NSUIFont {
        #if os(macOS)
        let descriptor = fontDescriptor.withSymbolicTraits(.italic)
        return NSUIFont(descriptor: descriptor, size: 0)!
        #else
        let descriptor = fontDescriptor.withSymbolicTraits(.traitItalic)!
        return NSUIFont(descriptor: descriptor, size: 0)
        #endif
    }

    func bold() -> NSUIFont {
        #if os(macOS)
        let descriptor = fontDescriptor.withSymbolicTraits(.bold)
        return NSUIFont(descriptor: descriptor, size: 0)!
        #else
        let descriptor = fontDescriptor.withSymbolicTraits(.traitBold)!
        return NSUIFont(descriptor: descriptor, size: 0)
        #endif
    }

    func leading(_ leading: Leading) -> NSUIFont {
        #if os(macOS)
        let descriptor = fontDescriptor.withSymbolicTraits(leading == .loose ? .looseLeading : .tightLeading)
        return NSUIFont(descriptor: descriptor, size: 0)!
        #else
        let descriptor = fontDescriptor.withSymbolicTraits(leading == .loose ? .traitLooseLeading : .traitTightLeading)!
        return NSUIFont(descriptor: descriptor, size: 0)
        #endif
    }

}
