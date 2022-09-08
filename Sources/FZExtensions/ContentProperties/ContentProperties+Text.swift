//
//  <ss.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)

import Foundation
import AppKit

public extension ContentProperties {
    struct Text {
        public enum TextTransform {
            case none
            case capitalized
            case lowercase
            case uppercase
        }
        
        public var font: NSFont = .systemFont(ofSize: NSFont.systemFontSize)
        public var color: NSUIColor = .black
        public var colorTransform: NSUIConfigurationColorTransformer? = nil
        public func resolvedColor() -> NSUIColor {
            return colorTransform?(color) ?? color
        }
        public var alignment: NSTextAlignment = .left
        public var lineBreakMode: NSLineBreakMode = .byTruncatingTail
        public var numberOfLines: Int = 1
        public var adjustsFontSizeToFitWidth: Bool = false
        public var minimumScaleFactor: CGFloat = 1.0
        public var allowsDefaultTighteningForTruncation: Bool = false
        public var adjustsFontForContentSizeCategory: Bool = false
        public var transform: TextTransform = .none
        public var showsExpansionTextWhenTruncated: Bool = false
        
        public init(font: NSFont = .systemFont(ofSize: NSFont.systemFontSize),
                    color: NSColor = .black,
                    colorTransform: NSUIConfigurationColorTransformer? = nil,
                    alignment: NSTextAlignment = .left,
                    lineBreakMode: NSLineBreakMode = .byTruncatingTail,
                    numberOfLines: Int = 1,
                    adjustsFontSizeToFitWidth: Bool = false,
                    minimumScaleFactor: CGFloat = 1.0,
                    allowsDefaultTighteningForTruncation: Bool = false,
                    adjustsFontForContentSizeCategory: Bool = false,
                    transform: TextTransform = .none,
                    showsExpansionTextWhenTruncated: Bool = false) {
            self.color = color
            self.colorTransform = colorTransform
            self.alignment = alignment
            self.lineBreakMode = lineBreakMode
            self.numberOfLines = numberOfLines
            self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            self.minimumScaleFactor = minimumScaleFactor
            self.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
            self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            self.transform = transform
            self.showsExpansionTextWhenTruncated = showsExpansionTextWhenTruncated
        }
        
        public static func system(size: CGFloat, weight: NSFont.Weight? = nil, color: NSColor = .textColor) -> Self {
            let font: NSFont
            if let weight = weight {
                font = NSFont.systemFont(ofSize: size, weight: weight)
            } else {
                font = NSFont.systemFont(ofSize: size)
            }
            var properties = Self()
            properties.font = font
            properties.color = color
            return properties
        }
        
        public static func system(controlSize: NSControl.ControlSize, weight: NSFont.Weight? = nil, color: NSColor = .textColor) -> Self {
            let size = NSFont.systemFontSize(for: controlSize)
            return self.system(size: size, weight: weight, color: color)
        }
    }
}

extension ContentProperties.Text: Hashable {
    public static func == (lhs: ContentProperties.Text, rhs: ContentProperties.Text) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public  func hash(into hasher: inout Hasher) {
        hasher.combine(self.font)
        hasher.combine(self.color)
        hasher.combine(self.alignment)
        hasher.combine(self.lineBreakMode)
        hasher.combine(self.numberOfLines)
        hasher.combine(self.adjustsFontSizeToFitWidth)
        hasher.combine(self.minimumScaleFactor)
        hasher.combine(self.allowsDefaultTighteningForTruncation)
        hasher.combine(self.adjustsFontForContentSizeCategory)
        hasher.combine(self.transform)
        hasher.combine(self.showsExpansionTextWhenTruncated)
    }
}


public extension NSTextField {
    func configurate(using textProperties: ContentProperties.Text) {
        self.font = textProperties.font
        self.textColor = textProperties.resolvedColor()
        self.lineBreakMode = textProperties.lineBreakMode
        self.alignment = textProperties.alignment
        self.maximumNumberOfLines = textProperties.numberOfLines
        self.attributedStringValue = self.attributedStringValue.transform(using: textProperties.transform)
        self.stringValue = self.stringValue.transform(using: textProperties.transform)
    }
}

public extension NSTextView {
    func configurate(using textProperties: ContentProperties.Text) {
        self.font = textProperties.font
        self.textColor = textProperties.resolvedColor()
        self.alignment = textProperties.alignment
        let attributedString = self.attributedString().transform(using: textProperties.transform)
        self.textStorage?.setAttributedString(attributedString)
        self.string = self.string.transform(using: textProperties.transform)
    }
}

public extension String {
    func transform(using transform: ContentProperties.Text.TextTransform) -> String {
        switch transform {
        case .none:
            return self
        case .capitalized:
            return self.capitalized
        case .lowercase:
            return self.lowercased()
        case .uppercase:
            return self.uppercased()
        }
    }
}

extension NSAttributedString {
    func transform(using transform: ContentProperties.Text.TextTransform) -> NSAttributedString {
        switch transform {
        case .none:
            return self
        case .capitalized:
            return self.capitalized()
        case .lowercase:
            return self.lowercased()
        case .uppercase:
            return self.uppercased()
        }
    }
}

#endif
