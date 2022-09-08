//
//  File.swift
//  
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)

import AppKit

public extension NSTextField {
    var textLayout: TextLayout? {
        get {
            switch (self.lineBreakMode, cell?.wraps, cell?.isScrollable) {
            case (.byWordWrapping, true, false):
                return .wraps
            case (.byTruncatingTail, false, false):
                return .truncates
            case (.byClipping, false, true):
                return .scrolls
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self.lineBreakMode = newValue.lineBreakMode
                self.usesSingleLineMode = false
                self.cell?.wraps = newValue.wraps
                self.cell?.isScrollable = newValue.isScrollable
            }
        }
    }
    
    enum TextLayout {
        case wraps
        case truncates
        case scrolls
        
       internal var isScrollable: Bool {
            return (self == .scrolls)
        }
       internal var wraps: Bool {
            return (self == .wraps)
        }
       internal var lineBreakMode: NSLineBreakMode {
            switch self {
            case .wraps:
                return .byWordWrapping
            case .truncates:
                return .byTruncatingTail
            case .scrolls:
                return .byClipping
            }
        }
    }
}

#endif
