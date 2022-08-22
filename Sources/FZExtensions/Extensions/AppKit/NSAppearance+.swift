//
//  NSApper.swift
//  NewImageViewer
//
//  Created by Florian Zand on 06.08.22.
//

#if os(macOS)

import Foundation
import AppKit

extension NSAppearance {
    static var vibrantDark: NSAppearance {
        return NSAppearance(named: .vibrantDark)!
    }
    
    static var vibrantLight: NSAppearance {
        return NSAppearance(named: .vibrantLight)!
    }
    
    static var aqua: NSAppearance {
        return NSAppearance(named: .aqua)!
    }
    
    static var darkAqua: NSAppearance {
        return NSAppearance(named: .darkAqua)!
    }
}

#endif
