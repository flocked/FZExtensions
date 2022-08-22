//
//  CodableValue.swift
//
//
//  Created by Denis Goldberg on 20.04.22.
//
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
///A property wrapper that adds Codable conformance to a generic type `T`, when the type cannot directly conform to Codable.
///
///The Type `T` is restricted to be one of the `SupportedCodableTypes` inside the property wrapper.
///
///- Note: If appending a property observer to your wrapped property, then make sure to apply any changes to the **$\<#Your Value#\>** property! Otherwise code will crash with bad access.
@propertyWrapper
public struct CodableValue<T: CodableValueSupported>: Codable {
    
    public var wrappedValue: T
    
    public var projectedValue: T { get { wrappedValue } set { wrappedValue = newValue } }
    
    ///Initializes `CodableValue`.
    ///
    ///- Parameter wrappedValue: The value of the wrapped property.
    public init(wrappedValue: T) { self.wrappedValue = wrappedValue }
    
    public init(from decoder: Decoder) throws {
        switch T.type {
        case .color:
            #if canImport(UIKit)
            wrappedValue = try Self.decode(UIColor.self, from: decoder)
            #elseif canImport(AppKit)
            wrappedValue = try Self.decode(NSColor.self, from: decoder)
            #endif
        case .image:
            #if canImport(UIKit)
            wrappedValue = try Self.decode(UIImage.self, from: decoder)
            #elseif canImport(AppKit)
            wrappedValue = try Self.decode(NSImage.self, from: decoder)
            #endif
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let data = try NSKeyedArchiver.archivedData(withRootObject: wrappedValue, requiringSecureCoding: true)
        try container.encode(data)
    }
    
    ///Modular function to simplify the code base.
    /// - Parameters:
    ///     - base: Relevant for decoding the actual type.
    ///     - decoder: The decoder that holds the requested data for the wrapped value.
    /// - Returns:
    ///     The decoded object as type `T`.
    /// - Throws: DecodingValueError when decoding fails.
    private static func decode<Base: NSObject>(_ base: Base.Type, from decoder: Decoder) throws -> T where Base: NSSecureCoding {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        if let decoded = try? NSKeyedUnarchiver.unarchivedObject(ofClass: base, from: data) as? T {
            return decoded
        } else {
            guard T.self is ExpressibleByNilLiteral.Type else { throw DecodingValueError<Base, T>.nonOptionalDecodingError }
            guard let noValue = Base?.none as? T else { throw DecodingValueError<Base, T>.decodingTypeMismatch }
            return noValue
        }
    }
}
//MARK: - Protocol Conformances
//Putting these extensions here, instead of in a separate file, so that the compiler can automatically generate the conformances for CodableValue.

extension CodableValue: Equatable where T: Equatable { }

extension CodableValue: Hashable where T: Hashable { }
