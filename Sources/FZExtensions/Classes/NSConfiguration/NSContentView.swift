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
#endif
