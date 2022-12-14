//
//  <ss.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 03.09.22.
//


#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@available(macOS 10.15.1, iOS 14.0, *)
public extension ContentProperties {
    struct Text {
        public enum TextTransform: Hashable {
            case none
            case capitalized
            case lowercase
            case uppercase
        }
        
        public var font: NSUIFont = NSUIFont.systemFont(ofSize: NSUIFont.systemFontSize)
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
        
        public init(font: NSUIFont = NSUIFont.systemFont(ofSize: NSUIFont.systemFontSize),
                    color: NSUIColor = .label,
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
        
        public static func system(size: CGFloat, weight: NSUIFont.Weight? = nil, color: NSUIColor = NSUIColor.label, numberOfLines: Int = 1) -> Self {
            let font: NSUIFont
            if let weight = weight {
                font = NSUIFont.systemFont(ofSize: size, weight: weight)
            } else {
                font = NSUIFont.systemFont(ofSize: size)
            }
            var properties = Self()
            properties.font = font
            properties.color = color
            properties.numberOfLines = numberOfLines
            if (numberOfLines == 1) {
                properties.lineBreakMode = .byTruncatingTail
            } else {
                properties.lineBreakMode = .byWordWrapping
            }
            return properties
        }
        
#if os(macOS)
        public static func system(_ fontSize: FontSize, weight: NSUIFont.Weight? = nil, color: NSUIColor = .labelColor, numberOfLines: Int = 1) -> Self {
            return self.system(size: fontSize.value, weight: weight, color: color, numberOfLines: numberOfLines)
        }
        
        public static func system(controlSize: NSControl.ControlSize, weight: NSUIFont.Weight? = nil, color: NSUIColor = .labelColor, numberOfLines: Int = 1) -> Self {
            return self.system(.controlSize(controlSize), weight: weight, color: color, numberOfLines: numberOfLines)
        }
        
        public static func system(tableRowSize: NSTableView.RowSizeStyle, weight: NSUIFont.Weight? = nil, color: NSUIColor = .labelColor, numberOfLines: Int = 1) -> Self {
            return self.system(.tableRowSize(tableRowSize), weight: weight, color: color, numberOfLines: numberOfLines)
        }
#endif

    }
}

@available(macOS 10.15.1, iOS 14.0, *)
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


#if os(macOS)
@available(macOS 10.15.1, iOS 14.0, *)
public extension ContentProperties.Text {
     enum FontSize: Hashable {
        case absolute(CGFloat)
        case controlSize(NSControl.ControlSize)
        case tableRowSize(NSTableView.RowSizeStyle)
        public var value: CGFloat {
            switch self {
            case .absolute(let value):
                return value
            case .controlSize(let value):
                return NSFont.systemFontSize(for: value)
            case .tableRowSize(let value):
                return NSFont.systemFontSize(forTableRowSize: value)
            }
        }
    }
}
#endif

#if os(macOS)
@available(macOS 10.15.1, iOS 14.0, *)
public extension NSTextField {
    func configurate(using textProperties: ContentProperties.Text) {
        self.font = textProperties.font
        self.textColor = textProperties.resolvedColor()
        self.lineBreakMode = textProperties.lineBreakMode
        self.alignment = textProperties.alignment
        self.maximumNumberOfLines = textProperties.numberOfLines
        self.stringValue = self.stringValue.transform(using: textProperties.transform)
        self.attributedStringValue = self.attributedStringValue.transform(using: textProperties.transform)
    }
}

@available(macOS 10.15.1, iOS 14.0, *)
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
#elseif canImport(UIKit)
@available(macOS 10.15.1, iOS 14.0, *)
public extension UILabel {
    func configurate(using textProperties: ContentProperties.Text) {
        self.font = textProperties.font
        self.textColor = textProperties.resolvedColor()
        self.numberOfLines = textProperties.numberOfLines
        self.textAlignment = textProperties.alignment
        self.lineBreakMode = textProperties.lineBreakMode
        self.attributedText = self.attributedText?.transform(using: textProperties.transform)
        self.text = self.text?.transform(using: textProperties.transform)
    }
}

@available(macOS 10.15.1, iOS 14.0, *)
public extension UITextField {
    func configurate(using textProperties: ContentProperties.Text) {
        self.font = textProperties.font
        self.textColor = textProperties.resolvedColor()
        self.textAlignment = textProperties.alignment
    //    self.lineBreakMode = textProperties.lineBreakMode
        self.attributedText = self.attributedText?.transform(using: textProperties.transform)
        self.text = self.text?.transform(using: textProperties.transform)
    }
}

@available(macOS 10.15.1, iOS 14.0, *)
public extension UITextView {
    func configurate(using textProperties: ContentProperties.Text) {
        self.font = textProperties.font
        self.textColor = textProperties.resolvedColor()
        self.textAlignment = textProperties.alignment
        self.attributedText = self.attributedText.transform(using: textProperties.transform)
        self.text = self.text.transform(using: textProperties.transform)
        self.textContainer.maximumNumberOfLines = textProperties.numberOfLines
        self.textContainer.lineBreakMode = textProperties.lineBreakMode
    }
}
// maximumNumberOfLines
#endif

@available(macOS 10.15.1, iOS 14.0, *)
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

@available(macOS 10.15.1, iOS 14.0, *)
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
