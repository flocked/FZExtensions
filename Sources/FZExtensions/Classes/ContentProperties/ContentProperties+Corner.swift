//
//  ContentProperties+ConerStyle.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 04.09.22.
//

import Foundation
import CoreGraphics

public extension ContentProperties {
    enum CornerStyle {
        case radius(CGFloat)
        case capsule
    }
}

#if os(macOS)
import AppKit
public extension NSView {
    func configurate(using cornerStlyeProperties: ContentProperties.CornerStyle) {
        self.wantsLayer = true
        switch cornerStlyeProperties {
        case .radius(let radius):
            self.layer?.cornerRadius = radius
        case .capsule:
            self.layer?.cornerRadius = self.bounds.height / 2.0
        }
    }
}

#elseif canImport(UIKit)
import UIKit
public extension UIView {
    func configurate(using cornerStlyeProperties: ContentProperties.CornerStyle) {
        switch cornerStlyeProperties {
        case .radius(let radius):
            self.layer.cornerRadius = radius
        case .capsule:
            self.layer.cornerRadius = self.bounds.height / 2.0
        }
    }
}

#endif
