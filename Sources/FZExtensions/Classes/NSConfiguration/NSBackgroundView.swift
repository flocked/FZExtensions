//
//  NSBackgroundView.swift
//  
//
//  Created by Florian Zand on 04.09.22.
//

#if os(macOS)
import AppKit

public protocol NSBackgroundView {
    var configuration: NSBackgroundConfiguration { get set }
    func supports(_ configuration: NSBackgroundConfiguration) -> Bool
}
#endif
