//
//  File.swift
//  
//
//  Created by Florian Zand on 21.10.22.
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public protocol BackgroundColorSettable {
    var backgroundColor: NSUIColor? { get set }
}

extension NSUIView: BackgroundColorSettable { }

#if os(macOS)
public extension BackgroundColorSettable where Self: NSView {
    internal var _effectiveAppearanceKVO: NSKeyValueObservation? {
        get { getAssociatedValue(key: "_effectiveAppearanceKVO", object: self) }
        set { set(associatedValue: newValue, key: "_effectiveAppearanceKVO", object: self) } }
    
    internal func updateBackgroundColor() {
        self.wantsLayer = true
        self.layer?.backgroundColor = self.backgroundColor?.resolvedColor(for: self.effectiveAppearance).cgColor
     }
    
    var backgroundColor: NSColor? {
        get { getAssociatedValue(key: "_backgroundColor", object: self) }
        set {
            set(associatedValue: newValue, key: "_backgroundColor", object: self)
            self.updateBackgroundColor()
            if newValue != nil {
                if (self._effectiveAppearanceKVO == nil) {
                    self._effectiveAppearanceKVO = self.observe(\.effectiveAppearance) { [weak self] object, change in
                        self?.updateBackgroundColor()
                    }
                }
            }
        }
    }
}
#endif
