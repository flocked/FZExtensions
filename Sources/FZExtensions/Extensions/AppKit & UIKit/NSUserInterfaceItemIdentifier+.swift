//
//  File.swift
//  
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)

import AppKit

extension NSUserInterfaceItemIdentifier: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
   public init(stringLiteral value: String) {
       self.init(rawValue: value)
    }
    
    public init(integerLiteral value: Int) {
        self.init(rawValue: String(value))
    }
}

#endif
