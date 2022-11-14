//
//  File.swift
//
//
//  Created by Florian Zand on 21.10.22.
//

#if os(macOS)
import AppKit

public enum NSViewCornerStyle: Equatable {
    case capsule
    case regular
    case relative(CGFloat)
}

public extension NSUIView {
    internal var _boundsKVO: NSKeyValueObservation? {
        get { getAssociatedValue(key: "_boundsKVO", object: self) }
        set { set(associatedValue: newValue, key: "_boundsKVO", object: self) } }
    
    internal func updateCornerStyle() {
        if cornerStyle != .regular {
            self.wantsLayer = true
            switch cornerStyle {
            case .relative(let value):
                let value = value.clamped(1.0)
                self.layer?.cornerRadius = (self.bounds.size.height / 2.0) * value
            case .capsule:
                self.layer?.cornerRadius = self.bounds.size.height / 2.0
            default:
                break
            }
        }
     }
    
    var cornerStyle: NSViewCornerStyle {
        get { getAssociatedValue(key: "_cornerStyle", object: self, initialValue: .regular) }
        set {
            set(associatedValue: newValue, key: "_cornerStyle", object: self)
            self.updateCornerStyle()
            if newValue != .regular {
                if (self._boundsKVO == nil) {
                    self._boundsKVO = self.observe(\.bounds) { [weak self] object, change in
                        self?.updateCornerStyle()
                    }
                }
            } else {
                _boundsKVO?.invalidate()
                _boundsKVO = nil
            }
        }
    }
}
#endif


