//
//  Optional+Ext.swift
//  
//
//  Created by Denis Goldberg on 22.04.22.
//

import Foundation

//Add conformance to CodableValue for when the type is an optional.
extension Optional: CodableValueSupported where Wrapped: CodableValueSupported {
    public static var type: SupportedCodableTypes { Wrapped.type }
}
