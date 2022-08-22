//
//  CodableValueSupported.swift
//  
//
//  Created by Denis Goldberg on 22.04.22.
//

import Foundation

///**INTERNAL USE ONLY**
///The types that conform to this protocol can be encoded and decdoded inside `CodableValue` as a wrapped property.
///
///- Attention: This protocol is intended for internal use only and should not be used in your codebase.
public protocol CodableValueSupported {
    ///The type that `CodableValue` supports and will use to decode the correct type.
    static var type: SupportedCodableTypes { get }
}


///`CodableValue` supports Encoding and Decoding of these types.
///
/// - Important: Using mismatching types will throw a `DecodingValueError` when `CodableValue` is initialized from a Decoder.
public enum SupportedCodableTypes: String, Codable { case image, color }
