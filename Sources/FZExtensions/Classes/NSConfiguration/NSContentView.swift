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
    var fittingSize: CGSize { get }
}

public extension NSContentView {
    func supports(_ configuration: NSContentConfiguration) -> Bool {
       return type(of: configuration) == type(of: self.configuration)
    }
}



#endif
