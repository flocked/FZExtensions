//
//  File.swift
//  
//
//  Created by Florian Zand on 24.09.22.
//

import SwiftUI

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension Font {
    init(_ font: NSUIFont) {
        self = Font(font as CTFont)
    }
}

@available(macOS 11.0, iOS 14.0, tvOS 12.2, watchOS 5.2, *)
extension NSUIFont.TextStyle {
    internal var swiftUI: Font.TextStyle {
        switch self {
        case .largeTitle: return .largeTitle
        case .title1: return .title
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .footnote: return .footnote
        case .caption1: return .caption
        case .caption2: return .caption2
        default:
            return .body
        }
    }
}

/*
 public extension Font {
 func weight(ui weight: NSUIFont.Weight) -> Font {
 switch weight {
 case .ultraLight: return self.weight(.ultraLight)
 case .thin: return self.weight(.thin)
 case .light: return self.weight(.light)
 case .regular: return self.weight(.regular)
 case .medium: return self.weight(.medium)
 case .heavy: return self.weight(.heavy)
 case .semibold: return self.weight(.semibold)
 case .bold: return self.weight(.bold)
 case .black: return self.weight(.black)
 default:
 return self
 }
 }
 }
 */
