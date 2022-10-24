//
//  File.swift
//  
//
//  Created by Florian Zand on 21.10.22.
//

#if os(macOS)
import AppKit

public protocol BackgroundStyleSettable {
    var backgroundStyle: NSView.BackgroundStyle { get set }
}

extension NSView: BackgroundStyleSettable { }

public extension BackgroundStyleSettable where Self: NSView {
    var backgroundStyle: NSView.BackgroundStyle  {
        get { getAssociatedValue(key: "_backgroundStyle", object: self, initialValue: .normal) }
        set { set(associatedValue: newValue, key: "_backgroundStyle", object: self) }
    }
}
#endif
