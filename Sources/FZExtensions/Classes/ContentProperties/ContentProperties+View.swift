//
//  ViewBackground.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 03.09.22.
//


#if os(macOS)
import AppKit
public typealias VisualEffect = ContentProperties.VisualEffect
#elseif canImport(UIKit)
import UIKit
public typealias VisualEffect = UIVisualEffect
#endif

extension ContentProperties {
    public struct View {
        public var cornerRadius: CGFloat = 0.0
        public var roundedCorners: CACornerMask = .all
        public var opacity: CGFloat = 1.0
        public var border: Border = Border()
        public var innerShadow: Shadow? = nil
        public var outerShadow: Shadow? = nil
        public var visualEffect: VisualEffect? = nil

        public var customView: NSUIView? = nil
        public var image: NSUIImage? = nil
        public var imageProperties: Image = .scaled(.resizeAspect)
        
        public var backgroundColor: NSUIColor? = nil
        public var backgroundColorTransformer: NSUIConfigurationColorTransformer? = nil
        
        public func resolvedBackgroundColor(for color: NSUIColor) -> NSUIColor {
            return backgroundColorTransformer?(color) ?? color
        }
        
        public init(cornerRadius: CGFloat = 0.0,
                    roundedCorners: CACornerMask = .all,
                    opacity: CGFloat = 1.0,
                    border: Border = Border(),
                    innerShadow: Shadow? = nil,
                    outerShadow: Shadow? = nil,
                    visualEffect: VisualEffect? = nil,
                    customView: NSUIView? = nil,
                    image: NSUIImage? = nil,
                    imageProperties: Image = .scaled(.resizeAspect),
                    backgroundColor: NSUIColor? = nil,
                    backgroundColorTransformer: NSUIConfigurationColorTransformer? = nil) {
            self.cornerRadius = cornerRadius
            self.roundedCorners = roundedCorners
            self.opacity = opacity
            self.border = border
            self.innerShadow = innerShadow
            self.outerShadow = outerShadow
            self.visualEffect = visualEffect
            self.customView = customView
            self.image = image
            self.imageProperties = imageProperties
            self.backgroundColor = backgroundColor
            self.backgroundColorTransformer = backgroundColorTransformer
        }
    }
}

extension ContentProperties.View: Hashable {
    public static func == (lhs: ContentProperties.View, rhs: ContentProperties.View) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.cornerRadius)
        hasher.combine(self.opacity)
        hasher.combine(self.border)
        hasher.combine(self.innerShadow)
        hasher.combine(self.outerShadow)
        hasher.combine(self.visualEffect)
        hasher.combine(self.customView)
        hasher.combine(self.image)
        hasher.combine(self.imageProperties)
        hasher.combine(self.backgroundColor)
    }
}

/*
 extension NSView {
 func configurate(using viewProperties: ContentProperties.View) {
 self.wantsLayer = true
 self.layer?.masksToBounds = true
 self.configurate(using: viewProperties.border)
 self.alphaValue = viewProperties.opacity
 self.backgroundColor = viewProperties.backgroundColor
 self.roundedCorners = viewProperties.roundedCorners
 self.cornerRadius = viewProperties.cornerRadius
 
 let customViewIdentifier: NSUserInterfaceItemIdentifier = "ContentProperties.View_CustomView"
 let visualEffectIdentifier: NSUserInterfaceItemIdentifier = "ContentProperties.View_VisualEffect"
 let imageViewIdentifier: NSUserInterfaceItemIdentifier = "ContentProperties.View_ImageView"
 self.subviews(identifier: customViewIdentifier).forEach({$0.removeFromSuperview()})
 self.subviews(identifier: visualEffectIdentifier).forEach({$0.removeFromSuperview()})
 self.subviews(identifier: imageViewIdentifier).forEach({$0.removeFromSuperview()})
 
 if let image = viewProperties.image {
 let imageView = ImageView(image: image)
 imageView.identifier = imageViewIdentifier
 self.addSubview(withConstraint: imageView)
 imageView.configurate(using: viewProperties.imageProperties)
 imageView.roundedCorners = viewProperties.roundedCorners
 imageView.cornerRadius = viewProperties.cornerRadius
 imageView.sendToBack()
 } else {
 self.subviews(identifier: imageViewIdentifier).forEach({$0.removeFromSuperview()})
 }
 
 if let customView = viewProperties.customView {
 customView.identifier = customViewIdentifier
 self.addSubview(withConstraint: customView)
 customView.cornerRadius = viewProperties.cornerRadius
 customView.roundedCorners = viewProperties.roundedCorners
 customView.sendToBack()
 } else {
 self.subviews(identifier: customViewIdentifier).forEach({$0.removeFromSuperview()})
 }
 
 if let visualEffectProperties = viewProperties.visualEffect {
 let visualEffectView = NSVisualEffectView()
 visualEffectView.identifier = visualEffectIdentifier
 self.addSubview(withConstraint: visualEffectView)
 visualEffectView.cornerRadius = viewProperties.cornerRadius
 visualEffectView.roundedCorners = viewProperties.roundedCorners
 visualEffectView.configurate(using: visualEffectProperties)
 visualEffectView.sendToBack()
 } else {
 self.subviews(identifier: visualEffectIdentifier).forEach({$0.removeFromSuperview()})
 }
 
 if let innerShadow = viewProperties.innerShadow {
 self.configurate(using: innerShadow)
 }
 
 if let outerShadow = viewProperties.outerShadow {
 self.configurate(using: outerShadow)
 }
 
 }
 }
 */
