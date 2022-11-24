//
//  File.swift
//  
//
//  Created by Florian Zand on 14.11.22.
//

#if os(macOS)
import Foundation
import AppKit

public extension NSCursor {
    class var resizeDiagonal: NSCursor? {
        if let image = NSImage(byReferencingFile: "/System/Library/Frameworks/WebKit.framework/Versions/Current/Frameworks/WebCore.framework/Resources/northWestSouthEastResizeCursor.png") {
            return NSCursor(image: image, hotSpot: NSPoint(x: 8, y: 8))
        }
        return nil
    }
}
#endif
