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
    
    public var color: NSColor?  {
        get { if let cgColor = self.shadowColor {
            return NSColor(cgColor: cgColor) }
            return nil }
        set { self.shadowColor = newValue?.cgColor } }
    
    
    
   private func update() {
        if self.superlayer != nil {
                var path = NSBezierPath(rect: self.bounds.insetBy(dx: -20, dy: -20))
                var   innerPart = NSBezierPath(rect: self.bounds).reversed
                if (self.cornerRadius != 0.0) {
                    path = NSBezierPath(roundedRect:  self.bounds.insetBy(dx: -20, dy: -20), xRadius: self.cornerRadius, yRadius: self.cornerRadius)
                    innerPart = NSBezierPath(roundedRect: self.bounds, xRadius: cornerRadius, yRadius: cornerRadius).reversed
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
