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

@available(macOS 10.15.1, iOS 14.0, *)
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
        
        public static func none() -> Self {
            return Self()
        }
    }
}

@available(macOS 10.15.1, iOS 14.0, *)
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
@available(macOS 10.15.1, iOS 14.0, *)
public extension NSView {

    
    func configurate(using borderProperties: ContentProperties.Border) {
        self.wantsLayer = true
        self.layer?.configurate(using: borderProperties)
    }
}
#elseif canImport(UIKit)
@available(macOS 10.15.1, iOS 14.0, *)
public extension UIView {
    func configurate(using borderProperties: ContentProperties.Border) {
        self.layer.configurate(using: borderProperties)
    }
}
#endif

@available(macOS 10.15.1, iOS 14.0, *)
public extension CALayer {
    func configurate(using borderProperties: ContentProperties.Border) {
        self.borderColor = borderProperties.color?.cgColor
        self.borderWidth = borderProperties.width
    }
}
