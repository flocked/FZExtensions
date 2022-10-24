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
}

public extension NSContentView {
    func supports(_ configuration: NSContentConfiguration) -> Bool {
       return type(of: configuration) == type(of: self.configuration)
    }
}



#endif
