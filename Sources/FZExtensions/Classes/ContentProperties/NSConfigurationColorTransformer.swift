//
//  ColorTransform.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 02.09.22.
//

#if os(macOS)
import Foundation
import AppKit

public struct NSConfigurationColorTransformer {
    public let transform: (NSColor) -> NSColor
    
    public func callAsFunction(_ input: NSColor) -> NSColor {
        return transform(input)
    }
    
    public init(_ transform: @escaping (NSColor) -> NSColor) {
        self.transform = transform
    }
    
   public static func opacity(_ opacity: CGFloat) -> Self {
        let transform: ((NSColor) -> NSColor) = { color in
            return color.withAlphaComponent(opacity.clamped(1.0))
        }
        return Self(transform)
    }
    
    public static func preferredTint(opacity: CGFloat = 1.0) -> Self {
        let transform: ((NSColor) -> NSColor) = { color in
            return .controlAccentColor.withAlphaComponent(opacity.clamped(1.0))
        }
        return Self(transform)
     }
    
    public static func systemEffect(_ systemEffect: NSColor.SystemEffect) -> Self {
        let transform: ((NSColor) -> NSColor) = { color in
            return color.withSystemEffect(systemEffect)
        }
        return Self(transform)
    }
    
    public static let monochrome: Self = Self({ color in
        return NSColor.secondaryLabelColor
    })
    
    public static let grayscale: Self = Self({ color in
        var color = color
        var white: CGFloat = 0
        var alpha: CGFloat = 0
        color.getWhite(&white, alpha: &alpha)
        return NSColor(white: white, alpha: alpha)
    })
}

#endif
