//
//  File.swift
//  CollectionTableView
//
//  Created by Florian Zand on 11.10.22.
//

#if os(macOS)
import AppKit
class VerticallyCenteredTextFieldCell: NSTextFieldCell {
    var focusRingCornerRadius: CGFloat = 0
    var shouldDrawFocusRing: Bool = true

    override func titleRect(forBounds rect: NSRect) -> NSRect {
        var titleRect = super.titleRect(forBounds: rect)
        let minimumHeight = self.cellSize(forBounds: rect).height
        titleRect.origin.y += (titleRect.size.height - minimumHeight) / 2
        titleRect.size.height = minimumHeight
        return titleRect
    }
    
    override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        super.edit(withFrame: titleRect(forBounds: rect), in: controlView, editor: textObj, delegate: delegate, event: event)
    }
    
    override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: titleRect(forBounds: cellFrame), in: controlView)
    }
        
    override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        super.select(withFrame: titleRect(forBounds: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
    }
    
    override func drawFocusRingMask(withFrame cellFrame: NSRect, in controlView: NSView) {
        guard shouldDrawFocusRing else {
            return
        }

        // Draw default
        guard focusRingCornerRadius > 0.0 else {
            super.drawFocusRingMask(withFrame: cellFrame, in: controlView)
            return
        }

        // Custome
        // Make forcus ring frame fit with cell size
        let newFrame = cellFrame.insetBy(dx: 2, dy: 1)
        let path = NSBezierPath(roundedRect: newFrame, xRadius: focusRingCornerRadius, yRadius: focusRingCornerRadius)
        path.fill()
    }
    
}
#endif
