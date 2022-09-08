//
//  File.swift
//  
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)

import AppKit

extension NSUserInterfaceItemIdentifier: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
   public init(stringLiteral value: Self.StringLiteralType) {
       self.init(rawValue: value)
    }

}

#endif
