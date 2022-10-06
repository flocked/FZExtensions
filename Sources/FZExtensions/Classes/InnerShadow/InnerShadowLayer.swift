//
//  self.swift
//  NewPrrooo
//
//  Created by Florian Zand on 16.09.21.
//

import Foundation
#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public class InnerShadowLayer: CALayer {
    public override var opacity: Float {
        get { return shadowOpacity }
        set {  shadowOpacity = newValue } }
    
    public var radius: CGFloat {
        get { self.shadowRadius }
        set { self.shadowRadius = newValue
            self.update()  } }
    
    public var offset: CGSize {
        get { self.shadowOffset }
        set { self.shadowOffset = newValue
            self.update()  } }
    
    public var color: NSUIColor?  {
        get { if let cgColor = self.shadowColor {
            return NSUIColor(cgColor: cgColor) }
            return nil }
        set { self.shadowColor = newValue?.cgColor } }
    
    public var properties: ContentProperties.Shadow {
        get {  ContentProperties.Shadow(color: self.color, opacity: CGFloat(self.opacity), radius: self.radius, offset: self.offset) }
        set {
            self.color = newValue.color
            self.opacity = Float(newValue.opacity)
            self.offset = newValue.offset
            self.radius = newValue.radius
        }
    }
    
    public override var frame: CGRect {
        didSet { self.update()  } }
    
    private func update() {
        if self.superlayer != nil {
            var path = NSUIBezierPath(rect: self.bounds.insetBy(dx: -20, dy: -20))
#if os(macOS)
            var   innerPart = NSUIBezierPath(rect: self.bounds).reversed
#else
            var   innerPart = NSUIBezierPath(rect: self.bounds).reversing()
#endif
            if (self.cornerRadius != 0.0) {
                path = NSUIBezierPath(roundedRect:  self.bounds.insetBy(dx: -20, dy: -20), cornerRadius: cornerRadius)
#if os(macOS)
                innerPart = NSUIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).reversed
#else
                innerPart = NSUIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).reversing()
#endif
            }
            path.append(innerPart)
            self.shadowPath = path.cgPath
            self.masksToBounds = true
            
            self.backgroundColor = .clear
        }
    }
    
    public override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        self.update()
    }
    
    public override func display() {
        super.display()
        self.update()
    }
}
