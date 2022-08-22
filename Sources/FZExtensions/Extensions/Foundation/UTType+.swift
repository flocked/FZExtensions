//
//  UTType+.swift
//  FZExtensions
//
//  Created by Florian Zand on 06.06.22.
//

import Foundation
import AVFoundation

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers

@available(macOS 11.0, *)
extension UTType {
    public func conforms(toAny uttypes: [UTType]) -> Bool {
        for uttype in uttypes {
            if (self.conforms(to: uttype)) {
                return true
            }
        }
       return false
    }
}

#endif

/*
@available(macOS 10.10, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
public struct UTType: Hashable {
    public static var gif: UTType = UTType(String(kUTTypeGIF))
    public  static var png: UTType = UTType(String(kUTTypePNG))

    
    public let identifier: String
    
    init(_ identifier: String) {
        self.identifier = identifier
    }
    
    
    public var isDeclared: Bool {
        return UTTypeIsDeclared(self.identifier as CFString)
    }
    
    public var isDynamic: Bool {
        return UTTypeIsDynamic(self.identifier as CFString)
    }
    
    public func conforms(to uttype: UTType) -> Bool {
       return UTTypeConformsTo(self.identifier as CFString, uttype.identifier as CFString)
    }
    
    
    public func conforms(toAny uttypes: [UTType]) -> Bool {
        for uttype in uttypes {
            if (self.conforms(to: uttype)) {
                return true
            }
        }
       return false
    }
    

    public var preferredMIMEType: String? {
        guard let preferredMIMEType = UTTypeCopyPreferredTagWithClass(self.identifier as CFString, kUTTagClassMIMEType) else {
            return nil
        }
        return String(preferredMIMEType.takeRetainedValue())
    }
    
    public var preferredFilenameExtension: String? {
        guard let preferredFilenameExtension = UTTypeCopyPreferredTagWithClass(self.identifier as CFString, kUTTagClassFilenameExtension) else {
            return nil
        }
        return String(preferredFilenameExtension.takeRetainedValue())
    }
}

*/
