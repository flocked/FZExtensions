//
//  NSView+Extensions.swift
//  SelectableArray
//
//  Created by Florian Zand on 19.10.21.
//

#if os(macOS)
import AppKit

extension NSView {
    public var frameInWindow: CGRect {
        convert(bounds, to: nil)
    }
    
    public var frameOnScreen: CGRect? {
        return self.window?.convertToScreen(frameInWindow)
    }
    
    public  var transform: CGAffineTransform {
        get {
            self.wantsLayer = true
            return self.layer!.affineTransform() }
        set {  self.layer?.setAffineTransform(newValue)  }
    }
    
    public var center: CGPoint {
        get { self.frame.center }
        set {  self.frame.center = newValue } }
    
    
    public var backgroundColor: NSColor? {
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
    
    public var alpha: CGFloat {
        get { if let cgValue =  self.layer?.opacity {
            return CGFloat(cgValue)
        }
            return 1.0  }
        set {
            self.wantsLayer = true
            self.layer?.opacity = Float(newValue) }
    }
    
    public var roundedCorners: CACornerMask {
        get { self.layer?.maskedCorners ?? CACornerMask() }
        set {
            self.wantsLayer = true
            self.layer?.maskedCorners = newValue
        }
    }
    
    public var cornerRadius: CGFloat {
        get { self.layer?.cornerRadius ?? 0.0 }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue }
    }
    
    public  func setAnchorPoint(_ anchorPoint:CGPoint) {
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
    
    public func moveSubview(_ view: NSView, to toIndex: Int) {
        if let index = self.subviews.firstIndex(of: view) {
            self.moveSubview(at: index, to: toIndex)
        }
    }
    
    public func moveSubviews(_ views: [NSView], to toIndex: Int, reorder: Bool = false) {
        var indexSet = IndexSet()
        for view in views {
            if let index = self.subviews.firstIndex(of: view), indexSet.contains(index) == false {
                indexSet.insert(index)
            }
        }
        if (indexSet.isEmpty == false) {
            self.moveSubviews(at: indexSet, to: toIndex, reorder: reorder)
        }
    }
    
    public func moveSubview(at index: Int, to toIndex: Int) {
        self.moveSubviews(at: IndexSet(integer: index), to: toIndex)
    }
    
    public func moveSubviews(at indexes: IndexSet, to toIndex: Int, reorder: Bool = false) {
        let subviewsCount = self.subviews.count
        if (self.subviews.isEmpty == false) {
            if (toIndex >= 0 && toIndex < subviewsCount) {
                var newIndexSet = IndexSet()
                for value in indexes {
                    if (value < subviewsCount && newIndexSet.contains(value) == false ) {
                        newIndexSet.insert(value)
                    }
                }
                
                var subviews = self.subviews
                if (reorder) {
                    for index in newIndexSet.reversed() {
                        subviews.moveItems(from: IndexSet(integer: index), to: toIndex)
                    }
                } else {
                    subviews.moveItems(from: newIndexSet, to: toIndex)
                }
                self.subviews = subviews
            }
        }
    }
    
    public func sendToFront() {
        if let superview = self.superview {
            superview.addSubview(self)
        }
    }
    
    public func sendToBack() {
        if let superview = self.superview, let firstView = superview.subviews.first, firstView != self {
            superview.addSubview(self, positioned: .below, relativeTo: firstView)
        }
    }
    
    public func addSubview(withAutoresizing view: NSView) {
        view.translatesAutoresizingMaskIntoConstraints = true
        if (self.bounds.size == .zero) {
            self.frame.size = CGSize(width: 1, height: 1)
        }
        
        view.frame.origin = .zero
        view.frame.size = self.bounds.size
        self.addSubview(view)
        view.autoresizingMask = .all
    }
    
    @discardableResult
    public func addSubview(withConstraint view: NSView) -> [NSLayoutConstraint]  {
        self.addSubview(view)
        return view.constraint(to: self)
    }
    
    public  func subviews<V: NSView>(type: V.Type) -> [V] {
        (self.subviews.filter({$0.isKind(of: type)}) as? [V]) ?? []
    }
    
    public func removeSubviews(type: NSView.Type) {
        self.subviews(type: type).forEach({$0.removeFromSuperview()})
    }
    
    @discardableResult
    public func constraint(to view: NSView) -> [NSLayoutConstraint]  {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = view.bounds
        let constraints = [NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0),
                           NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0),
                           NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0),
                           NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0)]
        constraints.forEach({$0.isActive = true})
        return constraints
    }
    
    public func addTrackingArea(rect: NSRect? = nil, options: NSTrackingArea.Options = [
        .mouseMoved,
        .mouseEnteredAndExited,
        .activeInKeyWindow]) {
            addTrackingArea(NSTrackingArea(
                rect: rect ?? self.bounds,
                options: options,
                owner: self))
        }
    
    public func removeAllTrackingAreas() {
        for trackingArea in self.trackingAreas {
            self.removeTrackingArea(trackingArea)
        }
    }
    
    @available(macOS 10.12, *)
    public  static func animate(withDuration duration:TimeInterval = 0.25, animations:@escaping ()->Void) {
        NSAnimationContext.runAnimationGroup() {
            context in
            context.duration = duration
            context.allowsImplicitAnimation = true
            animations()
        }
    }
    
    @available(OSX 10.12, *)
    public func animateLayout(changes: (NSAnimationContext) -> Void) {
        layoutSubtreeIfNeeded()

        NSAnimationContext.runAnimationGroup { (context) in
            context.allowsImplicitAnimation = true

            changes(context)

            self.layoutSubtreeIfNeeded()
        }
    }
    
    public func setNeedsDisplay() {
        self.needsDisplay = true
    }
    
    public  func setNeedsLayout() {
        self.needsLayout = true
    }
    
    public  func setNeedsUpdateConstraints() {
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
extension UIView {
   public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius ?? 0.0
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}
#endif

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
extension NSUIView {
    public func removeAllConstraints() {
        var _superview = self.superview
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? NSUIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? NSUIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        self.removeConstraints(self.constraints)
    }
}
