//
//  CALayer+.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//

import Foundation
import QuartzCore

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension CACornerMask {
    static let bottomLeft = CACornerMask.layerMinXMaxYCorner
    static let bottomRight = CACornerMask.layerMaxXMaxYCorner
    static let topLeft = CACornerMask.layerMinXMinYCorner
    static let topRight = CACornerMask.layerMaxXMinYCorner
    static let all: CACornerMask = [.bottomLeft, .bottomRight, .topLeft, .topRight]
    static let none: CACornerMask = []
}

public extension CALayer {
    func sendToFront() {
        guard let superlayer = superlayer else { return }
        removeFromSuperlayer()
        superlayer.addSublayer(self)
    }
    
    func sendToBack() {
        guard let superlayer = superlayer else { return }
        removeFromSuperlayer()
        superlayer.insertSublayer(self, at: 0)
    }
    
    #if os(macOS)
    func addSublayer(withAutoresizing layer: CALayer) {
        layer.frame = self.bounds
        layer.cornerRadius = self.cornerRadius
        layer.maskedCorners = self.maskedCorners
        layer.masksToBounds = true
        layer.autoresizingMask = .all
        self.addSublayer(layer)
    }
    
    var nsBackgroundColor: NSColor? {
        get {
            if let cgColor = self.backgroundColor {  return NSColor(cgColor: cgColor) }
            return nil
        }
        set { self.backgroundColor = newValue?.cgColor  }
    }
    #elseif canImport(UIKit)
    var uiBackgroundColor: NSUIColor? {
        get {
            if let cgColor = self.backgroundColor {  return UIColor(cgColor: cgColor) }
            return nil
        }
        set { self.backgroundColor = newValue?.cgColor  }
    }
    #endif
    
    @discardableResult
    func addSublayer(withConstraint layer: CALayer) -> [NSLayoutConstraint]  {
        self.addSublayer(layer)
        layer.cornerRadius = self.cornerRadius
        layer.maskedCorners = self.maskedCorners
        layer.masksToBounds = true
        return layer.constraintTo(layer: self)
    }
    
    
    
    @discardableResult
    func constraintTo(layer: CALayer) -> [NSLayoutConstraint] {
        self.frame = layer.bounds
        let constrains = [
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: layer, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: layer, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: layer, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: layer, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0)]
        constrains.forEach({$0.isActive = true})
        return constrains
    }
    
    func removeSublayers(type: CALayer.Type) {
        if let sublayers = self.sublayers {
            for sublayer in sublayers {
                if (sublayer.isKind(of: type)) {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
    }
}

#if os(macOS)
public extension CAAutoresizingMask {
    static let all: CAAutoresizingMask = [.layerHeightSizable, .layerWidthSizable, .layerMinXMargin, .layerMinYMargin, .layerMaxXMargin, .layerMaxYMargin]
}
#endif
