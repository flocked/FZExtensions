//
//  File.swift
//  CollectionTableView
//
//  Created by Florian Zand on 11.10.22.
//

#if os(macOS)
import AppKit
public class VerticallyCenteredTextFieldCell: NSTextFieldCell {
    public enum FocusType: Equatable {
        case none
        case capsule
        case roundedCorners(CGFloat)
        case roundedCornersRelative(CGFloat)
        case `default`
    }
    
    internal var isEditingOrSelecting = false
    public var focusType: FocusType = FocusType.default
  //  internal var isEditingHandler: ((Bool)->())? = nil

    public override func titleRect(forBounds rect: NSRect) -> NSRect {
        var titleRect = super.titleRect(forBounds: rect)
        let minimumHeight = self.cellSize(forBounds: rect).height
        titleRect.origin.y += (titleRect.size.height - minimumHeight) / 2
        titleRect.size.height = minimumHeight
        return titleRect
    }
    
    public override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.drawInterior(withFrame: titleRect(forBounds: cellFrame), in: controlView)
    }
    
    public override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
        isEditingOrSelecting = true
        super.edit(withFrame: titleRect(forBounds: rect), in: controlView, editor: textObj, delegate: delegate, event: event)
        isEditingOrSelecting = false
    }

    public override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
        isEditingOrSelecting = true
        super.select(withFrame: titleRect(forBounds: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
        isEditingOrSelecting = false
    }
    
    public override func drawFocusRingMask(withFrame cellFrame: NSRect, in controlView: NSView) {
        guard focusType != FocusType.none else {
            return
        }

        var cornerRadius: CGFloat = 0
        switch focusType {
        case .capsule:
            cornerRadius = cellFrame.size.height/2.0
        case .roundedCorners(let radius):
            cornerRadius = radius
        case .roundedCornersRelative(let relative):
            cornerRadius = cellFrame.size.height/2.0
            cornerRadius = cornerRadius * relative.clamped(0.0...1.0)
        default:
            break
        }
        
        // Draw default
        guard self.focusType != FocusType.default && cornerRadius != 0 else {
            super.drawFocusRingMask(withFrame: cellFrame, in: controlView)
            return
        }

        // Custome
        // Make forcus ring frame fit with cell size
       // let newFrame = cellFrame.insetBy(dx: 2, dy: 1)
        let newFrame = cellFrame
        
        let path = NSBezierPath(roundedRect: newFrame, xRadius: cornerRadius, yRadius: cornerRadius)
        path.fill()
    }
    
}

public class AAVerticallyCenteredTextFieldCell: NSTextFieldCell {
    public enum FocusType: Equatable {
        case none
        case capsule
        case roundedCorners(CGFloat)
        case roundedCornersRelative(CGFloat)
        case `default`
    }
    
    public var focusType: FocusType = FocusType.default
    public var leftPadding: CGFloat = 10.0
   public var rightPadding: CGFloat = 10.0
    private var isEditingOrSelecting = false

    public override func drawingRect(forBounds theRect: NSRect) -> NSRect {
        var newRect = super.drawingRect(forBounds: theRect)

        // Padding
        newRect.origin.x += leftPadding
        newRect.size.width -= leftPadding
        newRect.size.width -= rightPadding

        // When the text field is being edited or selected, we have to turn off the magic because it screws up
        // the configuration of the field editor.  We sneak around this by intercepting selectWithFrame and editWithFrame and sneaking a
        // reduced, centered rect in at the last minute.
        if !isEditingOrSelecting {
            // Get our ideal size for current text
            let textSize = self.cellSize(forBounds: theRect)

            //Center in the proposed rect
            let heightDelta = newRect.size.height - textSize.height
            if heightDelta > 0 {
                newRect.size.height -= heightDelta
                newRect.origin.y += heightDelta/2
            }
        }

        return newRect
    }

    public override func select(withFrame rect: NSRect,
                         in controlView: NSView,
                         editor textObj: NSText,
                         delegate: Any?,
                         start selStart: Int,
                         length selLength: Int) {
        let newRect = self.drawingRect(forBounds: rect)
        isEditingOrSelecting = true
        super.select(withFrame: newRect, in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
        isEditingOrSelecting = false
    }

    public override func edit(withFrame rect: NSRect,
                       in controlView: NSView,
                       editor textObj: NSText,
                       delegate: Any?,
                       event: NSEvent?) {
        let newRect = self.drawingRect(forBounds: rect)
        isEditingOrSelecting = true
        super.edit(withFrame: newRect, in: controlView, editor: textObj, delegate: delegate, event: event)
        isEditingOrSelecting = false
    }

    public override func drawFocusRingMask(withFrame cellFrame: NSRect, in controlView: NSView) {
        guard focusType != FocusType.none else {
            return
        }

        var cornerRadius: CGFloat = 0
        switch focusType {
        case .capsule:
            cornerRadius = cellFrame.size.height/2.0
        case .roundedCorners(let radius):
            cornerRadius = radius
        case .roundedCornersRelative(let relative):
            cornerRadius = cellFrame.size.height/2.0
            cornerRadius = cornerRadius * relative.clamped(0.0...1.0)
        default:
            break
        }
        
        // Draw default
        guard self.focusType != FocusType.default && cornerRadius != 0 else {
            super.drawFocusRingMask(withFrame: cellFrame, in: controlView)
            return
        }

        // Custome
        // Make forcus ring frame fit with cell size
       // let newFrame = cellFrame.insetBy(dx: 2, dy: 1)
        let newFrame = cellFrame
        
        let path = NSBezierPath(roundedRect: newFrame, xRadius: cornerRadius, yRadius: cornerRadius)
        path.fill()
    }
}

#endif
