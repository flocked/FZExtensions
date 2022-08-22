//
//  NSView+RenderedImage.swift
//  FZExtensions
//
//  Created by Florian Zand on 22.08.22.
//

#if os(macOS)

import AppKit

extension NSView {
    public static var currentContext: CGContext? {
       return NSGraphicsContext.current?.cgContext
    }

    public var renderedImage: NSImage  {
        let image = NSImage(size:self.bounds.size)
        image.lockFocus()
        
        if let context = Self.currentContext {
            self.layer?.render(in: context)
        }
        
        image.unlockFocus()
        return image
    }

    public static func renderedImage(from views:[NSView]) -> NSImage {
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
    
    public func enclosingRect(for subviews: [NSView]) -> CGRect {
        var enlosingFrame = CGRect.zero
        for subview in subviews {
            let frame = self.convert(subview.bounds, from:subview)
            enlosingFrame = NSUnionRect(enlosingFrame, frame)
        }
        return enlosingFrame
    }
}

#endif
