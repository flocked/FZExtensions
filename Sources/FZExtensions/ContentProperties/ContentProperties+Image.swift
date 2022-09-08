//
//  ImagePropertiesContentConfiguration.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 03.09.22.
//


import Foundation
import CoreGraphics

extension ContentProperties {
    public   struct Image {
        public  var tintColor: NSUIColor? = nil
        public   var tintColorTransformer: NSUIConfigurationColorTransformer? = nil
        public  func resolvedTintColor(for color: NSUIColor) -> NSUIColor {
        return tintColorTransformer?(color) ?? color
    }
        public   var cornerRadius: CGFloat = 0.0
        public  var maximumSize: CGSize = .zero
        public var reservedLayoutSize: CGSize = .zero
        public   var accessibilityIgnoresInvertColors: Bool = false
        public    var scaling: CALayerContentsGravity = .resizeAspectFill
    
      public  static func scaled(_ scaling: CALayerContentsGravity, maxSize: CGSize = .zero) -> Self { return Self(tintColor: nil, tintColorTransformer: nil, cornerRadius: 0.0, maximumSize: .zero, reservedLayoutSize: .zero, accessibilityIgnoresInvertColors: false, scaling: scaling)}
        public  static func scaledTinted(_ scaling: CALayerContentsGravity, tintColor: NSUIColor) -> Self { return Self(tintColor: tintColor, tintColorTransformer: nil, cornerRadius: 0.0, maximumSize: .zero, reservedLayoutSize: .zero, accessibilityIgnoresInvertColors: false, scaling: scaling)}
        public static func rounded(_ cornerRadius: CGFloat, scaling: CALayerContentsGravity = .resizeAspectFill) -> Self { return Self(tintColor: nil, tintColorTransformer: nil, cornerRadius: cornerRadius, maximumSize: .zero, reservedLayoutSize: .zero, accessibilityIgnoresInvertColors: false, scaling: scaling)}

        public init(tintColor: NSUIColor? = nil,
                    tintColorTransformer: NSUIConfigurationColorTransformer? = nil,
                    cornerRadius: CGFloat = 0.0,
                    maximumSize: CGSize = .zero,
                    reservedLayoutSize: CGSize = .zero,
                    accessibilityIgnoresInvertColors: Bool = false,
                    scaling: CALayerContentsGravity = .resizeAspectFill) {
            self.tintColor = tintColor
            self.tintColorTransformer = tintColorTransformer
            self.cornerRadius = cornerRadius
            self.maximumSize = maximumSize
            self.reservedLayoutSize = reservedLayoutSize
            self.accessibilityIgnoresInvertColors = accessibilityIgnoresInvertColors
            self.scaling = scaling
        }
        
        public static func `default`() -> Self { return .scaled(.resizeAspectFill)}
    
}
}

extension ContentProperties.Image: Hashable {
    public   static func == (lhs: ContentProperties.Image, rhs: ContentProperties.Image) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
       hasher.combine(self.tintColor)
       hasher.combine(self.cornerRadius)
        hasher.combine(self.maximumSize)
        hasher.combine(self.reservedLayoutSize)
        hasher.combine(self.accessibilityIgnoresInvertColors)
        hasher.combine(self.scaling)
   }
}



#if os(macOS)
import AppKit
public extension ImageView {
    func configurate(using imageProperties: ContentProperties.Image) {
        self.contentTintColor = imageProperties.tintColor
        self.cornerRadius = imageProperties.cornerRadius
        self.imageScaling = imageProperties.scaling
    }
}

public extension NSImageView {
    func configurate(using imageProperties: ContentProperties.Image) {
        self.contentTintColor = imageProperties.tintColor
        self.cornerRadius = imageProperties.cornerRadius
        self.imageScaling = NSImageScaling(contentsGravity: imageProperties.scaling)
    }
}

#elseif canImport(UIKit)
import UIKit
public extension UIImageView {
    func configurate(using imageProperties: ContentProperties.Image) {
        self.contentTintColor = imageProperties.tintColor
        self.cornerRadius = imageProperties.cornerRadius
        self.contentMode = UIView.ContentType(contentsGravity: imageProperties.scaling)
    }
}

#endif

