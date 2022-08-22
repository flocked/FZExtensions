//
//  NSView+Extensions.swift
//  SelectableArray
//
//  Created by Florian Zand on 19.10.21.
//

#if os(macOS)

import Foundation
import AppKit

extension NSVisualEffectView {
    func roundCorners(withRadius cornerRadius: CGFloat) {
      if #available(macOS 10.14, *) {
        maskImage = .maskImage(cornerRadius: cornerRadius)
      } else {
        layer?.cornerRadius = cornerRadius
      }
    }
}

#endif
