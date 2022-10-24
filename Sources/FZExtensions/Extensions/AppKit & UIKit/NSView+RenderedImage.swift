//
//  NSView+RenderedImage.swift
//  FZExtensions
//
//  Created by Florian Zand on 22.08.22.
//

#if os(macOS)

import AppKit

public extension NSView {
     static var currentContext: CGContext? {
       return NSGraphicsContext.current?.cgContext
    }

     var renderedImage: NSImage  {
        let image = NSImage(size:self.bounds.size)
        image.lockFocus()
        
        if let context = Self.currentContext {
            self.layer?.render(in: context)
        }
        
        image.unlockFocus()
        return image
    }

     static func renderedImage(from views:[NSView]) -> NSImage {
        var frame = CGRect.zero
        for view in views {
            frame = NSUnionRect(frame, view.frame)
        }
                
        let image = NSImage(size:frame.size)
        image.lockFocus()
        
        for view in views {
            let rect = view.frame
            view.renderedImage.draw(in:rect)
        }
        image.unlockFocus()
        return image
    }
}

#endif
