//
//  NSFont+.swift
//  FZCollection
//
//  Created by Florian Zand on 18.05.22.
//

#if os(macOS)

import Foundation
import AppKit

extension NSFont {
    var lineHeight: CGFloat {
        return self.boundingRectForFont.size.height
    }
    
    func sized(toFit text: String, width: CGFloat) -> NSFont {
        let font = self.withSize(1)
        var textSize = text.size(withAttributes: [.font: font])
        var newPointSize = font.pointSize

        while textSize.width < width {
            newPointSize += 1
            let newFont = NSFont(name: font.fontName, size: newPointSize)!
            textSize = text.size(withAttributes: [.font: newFont])
        }
        return self.withSize(newPointSize)
    }
}

#endif
