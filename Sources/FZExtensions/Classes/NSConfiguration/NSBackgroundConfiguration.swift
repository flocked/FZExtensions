//
//  NSBackgroundConfiguration.swift
//  
//
//  Created by Florian Zand on 04.09.22.
//

#if os(macOS)
import AppKit

public protocol NSBackgroundConfiguration {
    func makeBackgroundView() -> NSView & NSBackgroundView
    func updated(for state: NSConfigurationState) -> Self
}
#endif
