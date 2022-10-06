//
//  Shadow.swift
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
    public struct Shadow: Hashable {
        public var color: NSUIColor? = .shadowColor
        public var opacity: CGFloat = 0.3
        public var radius: CGFloat = 2.0
        public var offset: CGSize = CGSize(width: 1.0, height: -1.5)
        
        internal var isInvisible: Bool {
            return (self.color == nil || self.opacity == 0.0)
        }
        
        public init(color: NSUIColor? = .shadowColor,
                    opacity: CGFloat = 0.3,
                    radius: CGFloat = 2.0,
                    offset: CGSize = CGSize(width: 1.0, height: -1.5)) {
            self.color = color
            self.opacity = opacity
            self.radius = radius
            self.offset = offset
        }
        
        public static func none() -> Self { return Self(color: nil, opacity: 0.0)}
        public static func `default`() -> Self { return Self() }
        #if os(macOS)
        public static func defaultAccent() -> Self { return Self(color: .controlAccentColor) }
        #endif
        public static func color(_ color: NSUIColor) -> Self {
            var value = Self()
            value.color = color
            return value }
    }
}

public extension CALayer {
    func configurate(using shadowProperties: ContentProperties.Shadow) {
        self.shadowColor = shadowProperties.color?.cgColor
        self.shadowOffset = shadowProperties.offset
        self.shadowRadius = shadowProperties.radius
        self.shadowOpacity = Float(shadowProperties.opacity)
        /*
        if (shadowProperties.color != nil && shadowProperties.opacity != 0.0) {
            if (self.cornerRadius == 0.0) {
                self.shadowPath = NSUIBezierPath(rect: self.bounds).cgPath
            } else if (self.maskedCorners == .all || self.maskedCorners == .none) {
                self.shadowPath = NSUIBezierPath(rect: self.bounds, cornerRadius: self.cornerRadius).cgPath
            } else {
                self.shadowPath = NSUIBezierPath(rect: self.bounds, cornerRadius: self.cornerRadius, roundedCorners: self.maskedCorners).cgPath
            }
        }
         */
    }
}
