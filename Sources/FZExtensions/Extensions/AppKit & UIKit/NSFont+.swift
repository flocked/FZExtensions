//
//  NSFont+.swift
//  FZCollection
//
//  Created by Florian Zand on 18.05.22.
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if os(macOS)
import AppKit
public extension NSFont {
    var lineHeight: CGFloat {
        var attributes = self.fontDescriptor.fontAttributes
        var font = self
        if ( attributes[.sizeCategory] != nil) {
        attributes[.sizeCategory] = nil
        if let usageValue = attributes[.uiUsage] as? String {
                if usageValue == "UICTFontTextStyleHeadline" {
                    attributes[.uiUsage] = "CTFontDemiUsage"
                } else if usageValue.contains("UICTFontTextStyle") {
                    attributes[.uiUsage] = "CTFontRegularUsage"
                }
            }
            font = NSFont(descriptor: NSUIFontDescriptor(fontAttributes: attributes), size: self.pointSize)!
        }
        let ctFont = font as CTFont
        return CTFontGetAscent(ctFont) + CTFontGetDescent(ctFont) + CTFontGetLeading(ctFont)
        // return self.boundingRectForFont.size.height
    }
        
    static func systemFont(ofTableRowSize tableRowSize: NSTableView.RowSizeStyle) -> NSFont {
        return .systemFont(ofSize: self.systemFontSize(forTableRowSize: tableRowSize))
    }
    
    static func systemFont(ofTableRowSize tableRowSize: NSTableView.RowSizeStyle, weight: NSFont.Weight) -> NSFont {
        return .systemFont(ofSize: self.systemFontSize(forTableRowSize: tableRowSize), weight: weight)
    }
    
    
    static func systemFontSize(forTableRowSize tableRowSize: NSTableView.RowSizeStyle) -> CGFloat {
        switch tableRowSize {
        case .small:
            return 11.0
        case .large:
            if #available(macOS 11.0, *) {
                return 15.0
            } else {
                return  13.0
            }
        default:
            return  13.0
        }
    }
    
    func sized(toFit text: String, height: CGFloat) -> NSFont {
        let font = self.withSize(1)
        var textSize = text.size(withAttributes: [.font: font])
        var newPointSize = font.pointSize

        while textSize.height < height {
            newPointSize += 1
            let newFont = NSFont(name: font.fontName, size: newPointSize)!
            textSize = text.size(withAttributes: [.font: newFont])
        }
        return self.withSize(newPointSize)
    }
    
    func sized(toFit text: String, width: CGFloat) -> NSFont {
        let font = self.withSize(1)
        var textSize = text.size(withAttributes: [.font: font])
        var newPointSize = font.pointSize

        while textSize.width < width {
            newPointSize += 1
            let newFont = NSFont(name: font.fontName, size: newPointSize)!
            textSize = text.size(withAttributes: [.font: newFont])
        }
        return self.withSize(newPointSize)
    }
}

#endif


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
    
    convenience init?(name: String) {
        self.init(name: name, size: NSUIFont.systemFontSize)
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
        self.includingSymbolicTraits(.italic)
#else
        self.includingSymbolicTraits(.traitItalic)
#endif
    }
    
    func monospaced() -> NSUIFont {
#if os(macOS)
        self.includingSymbolicTraits(.monoSpace)
#else
        self.includingSymbolicTraits(.traitMonoSpace)
#endif
    }
    
    func bold() -> NSUIFont {
#if os(macOS)
        self.includingSymbolicTraits(.bold)
#else
        self.includingSymbolicTraits(.traitBold)
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
    
    func serif() -> NSUIFont? {
        if let descriptor = fontDescriptor.withDesign(.serif) {
            return NSUIFont(descriptor: descriptor, size: 0)
        }
        return nil
    }
    
    func rounded() -> NSUIFont? {
        if let descriptor = fontDescriptor.withDesign(.rounded) {
            return NSUIFont(descriptor: descriptor, size: 0)
        }
        return nil
    }
    
    func leading(_ leading: Leading) -> NSUIFont {
#if os(macOS)
        self.includingSymbolicTraits(leading == .loose ? .looseLeading : .tightLeading, without: leading != .loose ? .looseLeading : .tightLeading)
#else
        self.includingSymbolicTraits(leading == .loose ? .traitLooseLeading : .traitTightLeading, without: leading != .loose ? .traitLooseLeading : .traitTightLeading)
#endif
    }
    
    internal func includingSymbolicTraits(_ symbolicTraits: NSUIFontDescriptor.SymbolicTraits, without: NSUIFontDescriptor.SymbolicTraits? = nil) -> NSUIFont  {
        var traits = self.fontDescriptor.symbolicTraits
        guard traits.contains(symbolicTraits) == false else { return self }
        if let without = without {
            traits.remove(without)
        }
        traits.insert(symbolicTraits)
        return self.symbolicTraits(symbolicTraits)
    }
    
    internal func withoutSymbolicTraits(_ symbolicTraits: NSUIFontDescriptor.SymbolicTraits) -> NSUIFont  {
        var traits = self.fontDescriptor.symbolicTraits
        guard traits.contains(symbolicTraits) == true else { return self }
        traits.remove(symbolicTraits)
        return self.symbolicTraits(symbolicTraits)
    }
    
    func width(_ width: FontWidth) -> NSUIFont {
        switch width {
        case .standard:
#if os(macOS)
        return self.withoutSymbolicTraits([.expanded, .condensed])
#else
        return self.withoutSymbolicTraits([.traitCondensed, .traitExpanded])
#endif
        default:
#if os(macOS)
            return self.includingSymbolicTraits(width == .condensed ? .condensed : .expanded, without: width == .expanded ? .condensed : .expanded)
#else
            return self.includingSymbolicTraits(width == .condensed ? .traitCondensed : .traitExpanded, without: width == .expanded ? .traitCondensed : .traitExpanded)
#endif
        }
    }
    
    enum Leading {
        case loose
        case tight
    }
    
    enum FontWidth {
        case condensed
        case expanded
        case standard
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

extension NSUIFontDescriptor.TraitKey {
    internal enum Design: String {
        case rounded = "NSCTFontUIFontDesignRounded"
        case monospaced = "NSCTFontUIFontDesignMonospaced"
        case serif = "NSCTFontUIFontDesignSerif"
    }
    
    internal static var design: Self {
        return .init(rawValue: "NSCTFontUIFontDesignTrait")
    }
}

extension NSUIFontDescriptor.AttributeName {
    internal static var sizeCategory: Self {
        return .init(rawValue: "NSCTFontSizeCategoryAttribute")
    }
    
    internal static var uiUsage: Self {
        return .init(rawValue: "NSCTFontUIUsageAttribute")
    }
    
    internal enum UIUsage: String {
        case systemUltraLight = "CTFontUltraLightUsage"
        case systemThin = "CTFontThinUsage"
        case systemLight = "CTFontLightUsage"
        case systemRegular = "CTFontRegularUsage"
        case systemMedium = "CTFontMediumUsage"
        case systemSemiBold = "CTFontDemiUsage"
        case systemBold = "CTFontBoldUsage"
        case systemHeavy = "CTFontHeavyUsage"
        case systemBlack = "CTFontBlackUsage"

        case body = "UICTFontTextStyleBody"
        case callout = "UICTFontTextStyleCallout"
        case caption1 = "UICTFontTextStyleCaption1"
        case caption2 = "UICTFontTextStyleCaption2"
        case headline = "UICTFontTextStyleHeadline"
        case subheadline = "UICTFontTextStyleSubhead"
        case largeTitle = "UICTFontTextStyleTitle0"
        case title1 = "UICTFontTextStyleTitle1"
        case title2 = "UICTFontTextStyleTitle2"
        case title3 = "UICTFontTextStyleTitle3"
    }
}
