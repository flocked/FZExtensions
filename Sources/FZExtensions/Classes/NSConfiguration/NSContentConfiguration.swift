//
//  NSContentConfiguration.swift
//  
//
//  Created by Florian Zand on 02.09.22.
//

#if os(macOS)
import AppKit

public protocol NSContentConfiguration {
    func makeContentView() -> NSView & NSContentView
    func updated(for state: NSConfigurationState) -> Self
}
#endif
