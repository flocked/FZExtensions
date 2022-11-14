//
//  File.swift
//  
//
//  Created by Florian Zand on 14.11.22.
//

#if os(macOS)
import Foundation
import AppKit

public extension NSResponder {
    var parentViewController: NSViewController? {
        return nextResponder as? NSViewController ?? nextResponder?.parentViewController
    }
}
#endif
