//
//  NSView+Extensions.swift
//  SelectableArray
//
//  Created by Florian Zand on 19.10.21.
//

#if os(macOS)

import AppKit

public extension NSView {
    var frameInWindow: CGRect {
        convert(bounds, to: nil)
    }
    
    var frameOnScreen: CGRect? {
        return self.window?.convertToScreen(frameInWindow)
    }
    
    var transform: CGAffineTransform {
        get {
            self.wantsLayer = true
            return self.layer!.affineTransform() }
        set {  self.layer?.setAffineTransform(newValue)  }
    }
    
    var center: CGPoint {
        get { self.frame.center }
        set {  self.frame.center = newValue } }
    
    
    var backgroundColor: NSColor? {
        get {
            if let cgColor = self.layer?.backgroundColor {
                return NSColor(cgColor: cgColor)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor }
    }
    
    var roundedCorners: CACornerMask {
        get { self.layer?.maskedCorners ?? CACornerMask() }
        set {
            self.wantsLayer = true
            self.layer?.maskedCorners = newValue
        }
    }
    
    var cornerRadius: CGFloat {
        get { self.layer?.cornerRadius ?? 0.0 }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue }
    }
    
    func setAnchorPoint(_ anchorPoint:CGPoint) {
        guard let layer = self.layer else { return }
        var newPoint = CGPoint(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(self.bounds.size.width * layer.anchorPoint.x, self.bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(layer.affineTransform())
        oldPoint = oldPoint.applying(layer.affineTransform())
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
    
    
    func sendToFront() {
        if let superview = self.superview {
            superview.addSubview(self)
        }
    }
    
    func sendToBack() {
        if let superview = self.superview, let firstView = superview.subviews.first, firstView != self {
            superview.addSubview(self, positioned: .below, relativeTo: firstView)
        }
    }
    
    func addSubview(withAutoresizing view: NSView) {
        self.addSubview(view)
        view.autoresizingMask = .all
    }
    
    @discardableResult
    func addSubview(withConstraint view: NSView) -> [NSLayoutConstraint]  {
        self.addSubview(view)
        return view.constraint(to: self)
    }
    
    func subviews(type: NSView.Type) -> [NSView] {
        self.subviews.filter({$0.isKind(of: type)})
    }
    
    func removeSubviews(type: NSView.Type) {
        self.subviews(type: type).forEach({$0.removeFromSuperview()})
    }
    
    @discardableResult
    func constraint(to view: NSView) -> [NSLayoutConstraint]  {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = view.bounds
        let constraints = [NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0),
                           NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0),
                           NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0),
                           NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0)]
        constraints.forEach({$0.isActive = true})
        return constraints
    }
    
    func addTrackingArea(rect: NSRect? = nil, options: NSTrackingArea.Options = [
        .mouseMoved,
        .mouseEnteredAndExited,
        .activeInKeyWindow]) {
            addTrackingArea(NSTrackingArea(
                rect: rect ?? self.bounds,
                options: options,
                owner: self))
        }
    
    func removeAllTrackingAreas() {
        for trackingArea in self.trackingAreas {
            self.removeTrackingArea(trackingArea)
        }
    }
    
    @available(macOS 10.12, *)
    static func animate(withDuration duration:TimeInterval = 0.25, animations:@escaping ()->Void) {
        NSAnimationContext.runAnimationGroup() {
            context in
            context.duration = duration
            context.allowsImplicitAnimation = true
            animations()
        }
    }
    
    func setNeedsDisplay() {
        self.needsDisplay = true
    }
    
    func setNeedsLayout() {
        self.needsLayout = true
    }
    
    func setNeedsUpdateConstraints() {
        self.needsUpdateConstraints = true
    }
}

public extension NSView.AutoresizingMask {
    static let none: NSView.AutoresizingMask = []
    static let flexibleSize: NSView.AutoresizingMask = [.height, .width]
    static let all: NSView.AutoresizingMask = [.height, .width, .minYMargin, .minXMargin, .maxXMargin, .maxYMargin]
}

#endif

#if canImport(UIKit)
import UIKit
extension View {
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius ?? 0.0
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
#endif

