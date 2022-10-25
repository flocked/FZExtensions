//
//  NSBackgroundView.swift
//  
//
//  Created by Florian Zand on 04.09.22.
//

#if os(macOS)
import AppKit

public protocol NSBackgroundView: Sizable {
    var configuration: NSBackgroundConfiguration { get set }
    func supports(_ configuration: NSBackgroundConfiguration) -> Bool
}

public extension NSBackgroundView {
    func supports(_ configuration: NSBackgroundConfiguration) -> Bool {
       return type(of: configuration) == type(of: self.configuration)
    }
}
#endif
