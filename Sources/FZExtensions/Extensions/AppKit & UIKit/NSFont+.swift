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

extension NSUIFontDescriptor.AttributeName {
    internal static var sizeCategory: Self {
        return .init(rawValue: "NSCTFontSizeCategoryAttribute")
    }
    internal static var uiUsage: Self {
        return .init(rawValue: "NSCTFontUIUsageAttribute")
    }
}
