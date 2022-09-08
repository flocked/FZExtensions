//
//  ViewBackground.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)

import AppKit


extension ContentProperties {
    public   struct View {
        var cornerRadius: CGFloat = 0.0
        var roundedCorners: CACornerMask = .all
        var opacity: CGFloat = 1.0
        var border: Border = Border()
        var innerShadow: Shadow? = nil
        var outerShadow: Shadow? = nil
        var visualEffect: VisualEffect? = nil
        var customView: NSView? = nil
        var image: NSImage? = nil
        var imageProperties: Image = .scaled(.resizeAspect)
        
        var backgroundColor: NSUIColor? = nil
        var backgroundColorTransformer: NSUIConfigurationColorTransformer? = nil
                
        func resolvedBackgroundColor(for color: NSUIColor) -> NSUIColor {
            return backgroundColorTransformer?(color) ?? color
        }
        
    }
}

extension ContentProperties.View: Hashable {
    public  static func == (lhs: ContentProperties.View, rhs: ContentProperties.View) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public    func hash(into hasher: inout Hasher) {
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
#endif
