//
//  Shadow.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)

import Foundation
import CoreGraphics

extension ContentProperties {
     public struct Shadow: Hashable {
        var color: NSUIColor? = .shadowColor
        var opacity: CGFloat = 0.3
        var radius: CGFloat = 2.0
        var offset: CGSize = CGSize(width: 1.0, height: -1.5)
        
        internal var isInvisible: Bool {
            return (self.color == nil || self.opacity == 0.0)
        }
        
        static func defaultShadow() -> Self { return Self() }
        static func defaultShadowAccent() -> Self { return Self(color: .controlAccentColor) }
        static func color(_ color: NSUIColor) -> Self {
            var value = Self()
            value.color = color
            return value }
    }
}

#endif
