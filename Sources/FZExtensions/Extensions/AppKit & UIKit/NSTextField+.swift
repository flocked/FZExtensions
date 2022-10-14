//
//  File.swift
//  
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)

import AppKit

public extension NSTextField {
    convenience init(layout: TextLayout) {
        self.init(frame: .zero)
        self.textLayout = layout
    }
    
    var truncatesLastVisibleLine: Bool {
        get { self.cell?.truncatesLastVisibleLine ?? false }
        set { self.cell?.truncatesLastVisibleLine = newValue }
    }
    
    convenience init(frame: CGRect, layout: TextLayout) {
        self.init(frame: frame)
        self.textLayout = layout
    }
    
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
    
    enum TextLayout: Int, CaseIterable {
        case truncates = 0
        case wraps = 1
        case scrolls = 2
        
        public init?(lineBreakMode: NSLineBreakMode) {
             guard let found = Self.allCases.first(where: {$0.lineBreakMode == lineBreakMode}) else { return nil  }
             self = found
        }
        
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
