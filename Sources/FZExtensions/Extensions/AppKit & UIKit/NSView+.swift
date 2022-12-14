//
//  NSView+Extensions.swift
//  SelectableArray
//
//  Created by Florian Zand on 19.10.21.
//

#if os(macOS)
import AppKit

extension NSView {
    public typealias ContentMode = CALayerContentsGravity

   public func enclosingRect(for subviews: [NSView]) -> CGRect {
       var enlosingFrame = CGRect.zero
       for subview in subviews {
           let frame = self.convert(subview.bounds, from:subview)
           enlosingFrame = NSUnionRect(enlosingFrame, frame)
       }
       return enlosingFrame
   }
    
    public var borderColor: NSColor? {
        get {
            if let cgColor = self.layer?.borderColor {
                return NSColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            self.wantsLayer = true
            self.layer?.borderColor = newValue?.cgColor
        }
    }
    
    public var borderWidth: CGFloat {
        get {
            self.layer?.borderWidth ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.borderWidth = newValue
        }
    }
    
    
    
    public var frameInWindow: CGRect {
        convert(bounds, to: nil)
    }
    
    public var frameOnScreen: CGRect? {
        return self.window?.convertToScreen(frameInWindow)
    }
        
    public var contentMode: ContentMode {
        get {   self.layer?.contentsGravity ?? .center }
        set {   self.wantsLayer = true
                self.layer?.contentsGravity = newValue } }
    
    public var maskToBounds: Bool {
        get {   self.layer?.masksToBounds ?? false }
        set {   self.wantsLayer = true
                self.layer?.masksToBounds = newValue } }
    
    public var mask: NSView? {
        get {    return getAssociatedValue(key: "_maskView", object: self) }
        set {
            self.layer?.mask = nil
            set(associatedValue: newValue, key: "_maskView", object: self)
            if let maskView = newValue {
                self.wantsLayer = true
                maskView.wantsLayer = true
                self.layer?.mask = maskView.layer
            }
        }
    }
    
    public var isOpaque: Bool {
        get {   self.layer?.isOpaque ?? false }
        set {   self.wantsLayer = true
                self.layer?.isOpaque = newValue } }
        
    public var transform: CGAffineTransform {
        get {   self.wantsLayer = true
                return self.layer?.affineTransform() ?? .init() }
        set {   self.wantsLayer = true
                self.layer?.setAffineTransform(newValue)  }
    }
    
    public var anchorPoint: CGPoint {
        get {   self.layer?.anchorPoint ?? .zero }
        set {   self.wantsLayer = true
                self.layer?.anchorPoint = newValue } }
    
    public var transform3D: CATransform3D {
        get {   self.wantsLayer = true
                return self.layer?.transform ?? .zero}
        set {   self.wantsLayer = true
                self.layer?.transform = newValue  } }
    
    public var center: CGPoint {
        get { self.frame.center }
        set { self.frame.center = newValue } }
    
    
    internal var alpha: CGFloat {
        get {   guard let cgValue = self.layer?.opacity else { return 1.0 }
                return CGFloat(cgValue) }
        set {   self.wantsLayer = true
                self.layer?.opacity = Float(newValue) } }
    
    public var roundedCorners: CACornerMask {
        get {   self.layer?.maskedCorners ?? CACornerMask() }
        set {   self.wantsLayer = true
                self.layer?.maskedCorners = newValue } }
    
    public var cornerRadius: CGFloat {
        get {   self.layer?.cornerRadius ?? 0.0 }
        set {   self.wantsLayer = true
                self.layer?.cornerRadius = newValue } }
    
    public var cornerCurve: CALayerCornerCurve {
        get {   self.layer?.cornerCurve ?? .circular  }
        set {   self.wantsLayer = true
                self.layer?.cornerCurve = newValue } }

    public func setAnchorPoint(_ anchorPoint:CGPoint) {
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
    
    public func firstSuperview<V: NSView>(for viewClass: V.Type) -> V? {
        if let superview = self.superview {
            if let view = superview as? V {
                return view
            }
            return superview.firstSuperview(for: viewClass)
        }
        return nil
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
    public  static func animate(withDuration duration:TimeInterval = 0.25, timingFunction: CAMediaTimingFunction, animations:@escaping ()->Void, completion: (()->Void)? = nil) {
        NSAnimationContext.runAnimationGroup() {
            context in
            context.duration = duration
            context.timingFunction = timingFunction
            context.allowsImplicitAnimation = true
            context.completionHandler = completion
            animations()
        }
    }
    
    @available(macOS 10.12, *)
    public  static func animate(withDuration duration:TimeInterval = 0.25, delay: TimeInterval, timingFunction: CAMediaTimingFunction? = nil, animations:@escaping ()->Void, completion: (()->Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NSAnimationContext.runAnimationGroup() {
                context in
                context.duration = duration
                context.timingFunction = timingFunction
                context.allowsImplicitAnimation = true
                context.completionHandler = completion
                animations()
            }
        }
    }
    
    @available(macOS 10.12, *)
    public  static func animate(withDuration duration:TimeInterval = 0.25, animations:@escaping ()->Void, completion: (()->Void)? = nil) {
        NSAnimationContext.runAnimationGroup() {
            context in
            context.duration = duration
            context.allowsImplicitAnimation = true
            context.completionHandler = completion
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
    
    public var parentController: NSViewController? {
        if let responder = self.nextResponder as? NSViewController {
            return responder
        } else if let responder = self.nextResponder as? NSView {
            return responder.parentController
        } else {
            return nil
        }
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
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
  public  var parentController: UIViewController? {
        if let responder = self.next as? UIViewController {
            return responder
        } else if let responder = self.next as? UIView {
            return responder.parentController
        } else {
            return nil
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

#if os(macOS)
extension CALayerContentsGravity {
   internal var viewLayerContentsPlacement: NSView.LayerContentsPlacement {
        switch self {
        case .topLeft: return .topLeft
        case .top: return .top
        case .topRight: return .topRight
        case .center: return .center
        case .bottomLeft: return .bottomLeft
        case .bottom: return .bottom
        case .bottomRight: return .bottomRight
        case .resize: return .scaleAxesIndependently
        case .resizeAspectFill: return .scaleProportionallyToFill
        case .resizeAspect: return .scaleProportionallyToFit
        case .left: return .left
        case .right: return .right
        default: return .scaleProportionallyToFill
    }
}
}
#endif
