//
//  NSImage+Ext.swift
//
//
//  Created by Denis Goldberg on 22.04.22.
//

#if canImport(UIKit)

import UIKit

extension UIImage: CodableValueSupported {
    public static let type = SupportedCodableTypes.image
}

#endif
