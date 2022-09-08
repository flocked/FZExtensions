//
//  Border.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 03.09.22.
//


#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension ContentProperties {
    public struct Border {
        public var color: NSUIColor? = nil
        public var colorTransformer: NSUIConfigurationColorTransformer? = nil
        public var width: CGFloat = 0.0
        public var pattern: [PatternValue] = [.line]
        public func resolvedColor(for color: NSUIColor) -> NSUIColor {
            return colorTransformer?(color) ?? color
        }
        
        public enum PatternValue: Int {
            case line
            case noLine
        }
        
        public init(color: NSUIColor? = nil,
                    colorTransformer: NSUIConfigurationColorTransformer? = nil,
                    width: CGFloat = 0.0,
                    pattern: [PatternValue] = [.line]) {
            self.color = color
            self.width = width
            self.pattern = pattern
            self.colorTransformer = colorTransformer
        }
    }
}

extension ContentProperties.Border: Hashable {
    public static func == (lhs: ContentProperties.Border, rhs: ContentProperties.Border) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.color)
        hasher.combine(self.width)
        hasher.combine(self.pattern)
    }
}


#if os(macOS)
public extension NSView {
    func configurate(using borderProperties: ContentProperties.Border) {
        self.wantsLayer = true
        self.layer?.borderColor = borderProperties.color?.cgColor
        self.layer?.borderWidth = borderProperties.width
    }
}
#elseif canImport(UIKit)
public extension UIView {
    func configurate(using borderProperties: ContentProperties.Border) {
        self.layer?.borderColor = borderProperties.color?.cgColor
        self.layer?.borderWidth = borderProperties.width
    }
}
#endif