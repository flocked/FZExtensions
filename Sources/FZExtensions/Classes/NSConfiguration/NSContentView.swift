//
//  NSContentView.swift
//  
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)
import AppKit

public protocol NSContentView {
    var configuration: NSContentConfiguration { get set }
    func supports(_ configuration: NSContentConfiguration) -> Bool
    func sizeThatFits(_ size: CGSize) -> CGSize
}

public extension NSContentView where Self: NSView {
     func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.frame.size
    }
}

#endif
