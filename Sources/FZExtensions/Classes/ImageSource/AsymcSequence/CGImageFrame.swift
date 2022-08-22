//
//  CGImageFrame.swift
//  FZExtensions
//
//  Created by Florian Zand on 22.08.22.
//

import Foundation

public struct CGImageFrame {
    var image: CGImage
    var duration: TimeInterval
    init(_ image: CGImage, _ duration: TimeInterval) {
        self.image = image
        self.duration = duration
    }
}

#if os(macOS)
import AppKit
public struct ImageFrame {
    var image: NSImage
    var duration: TimeInterval
    init(_ image: NSImage, _ duration: TimeInterval) {
        self.image = image
        self.duration = duration
    }
}
#elseif canImport(UIKit)
import UIKit
public struct ImageFrame {
    var image: UIImage
    var duration: TimeInterval
    init(_ image: UIImage, _ duration: TimeInterval) {
        self.image = image
        self.duration = duration
    }
}
#endif
