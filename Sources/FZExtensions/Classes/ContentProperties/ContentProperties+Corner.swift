//
//  ContentProperties+ConerStyle.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 04.09.22.
//

import Foundation
import CoreGraphics

public extension ContentProperties {
    enum CornerStyle: Hashable {
        case radius(CGFloat)
        case capsule
        
        static var none: Self {
            return .radius(0.0)
        }
        
        static var small: Self {
            return .radius(4.0)
        }
        static var medium: Self {
            return .radius(8.0)
        }
        static var large: Self {
            return .radius(12.0)
        }
    }
}

public extension CALayer {
    func configurate(using cornerStyleProperties: ContentProperties.CornerStyle) {
        switch cornerStyleProperties {
        case .radius(let radius):
            self.cornerRadius = radius
        case .capsule:
            self.cornerRadius = self.bounds.height / 2.0
        }
    }
}

#if os(macOS)
import AppKit
public extension NSView {
    func configurate(using cornerStyleProperties: ContentProperties.CornerStyle) {
        self.wantsLayer = true
        self.layer?.configurate(using: cornerStyleProperties)
    }
}

#elseif canImport(UIKit)
import UIKit
public extension UIView {
    func configurate(using cornerStyleProperties: ContentProperties.CornerStyle) {
        self.layer.configurate(using: cornerStyleProperties)
    }
}

#endif
