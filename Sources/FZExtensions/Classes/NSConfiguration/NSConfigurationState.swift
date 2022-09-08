//
//  NSConfigurationState.swift
//  
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)
import Foundation
public protocol NSConfigurationState {
    subscript(key: NSConfigurationStateCustomKey) -> AnyHashable? { get set }
}

public struct NSConfigurationStateCustomKey: Hashable, RawRepresentable {
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var rawValue: String
    public typealias RawValue = String
}

extension NSConfigurationStateCustomKey: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        self.init(rawValue: value)!
    }
}
#endif
