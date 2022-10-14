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

public extension NSContentView {
    func supports(_ configuration: NSContentConfiguration) -> Bool {
       return type(of: configuration) == type(of: self.configuration)
    }
}

public extension NSContentView where Self: NSView {
     func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.fittingSize
    }
    
    func sizeThatFits(width: CGFloat?, height: CGFloat?) -> CGSize {
        return self.sizeThatFits(CGSize(width: width ?? .infinity, height: height ?? .infinity))
    }
}


#endif
