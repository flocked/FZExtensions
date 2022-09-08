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
        
        public static func defaultShadow() -> Self { return Self() }
        public static func defaultShadowAccent() -> Self { return Self(color: .controlAccentColor) }
        public static func color(_ color: NSUIColor) -> Self {
            var value = Self()
            value.color = color
            return value }
    }
}
