//
//  File.swift
//  
//
//  Created by Florian Zand on 02.11.22.
//

import Cocoa

public extension NSRunningApplication {
    
    /// A covenience var for getting the frontmost application.
    class var frontmostApplication: NSRunningApplication! {
        return NSWorkspace.shared.frontmostApplication
    }
    
}
