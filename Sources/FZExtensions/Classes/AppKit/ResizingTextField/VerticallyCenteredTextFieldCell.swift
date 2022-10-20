//
//  File.swift
//  CollectionTableView
//
//  Created by Florian Zand on 11.10.22.
//

#if os(macOS)
import AppKit

public class FZTextField: NSTextField {
    public override class var cellClass: AnyClass? {
         get { VerticallyCenteredTextFieldCell.self }
         set { super.cellClass = newValue }
     }
    
    internal var textCell: VerticallyCenteredTextFieldCell? {
        self.cell as? VerticallyCenteredTextFieldCell
    }
    
    public var focusType: VerticallyCenteredTextFieldCell.FocusType {
        get { textCell?.focusType ?? .default }
        set { textCell?.focusType = newValue }
    }
    
    public var verticalAlignment: VerticallyCenteredTextFieldCell.VerticalAlignment {
        get { textCell?.verticalAlignment ?? .default}
        set { textCell?.verticalAlignment = newValue }
    }
}

public class VerticallyCenteredTextFieldCell: NSTextFieldCell {
    public enum FocusType: Equatable {
        case none
        case capsule
        case roundedCorners(CGFloat)
        case roundedCornersRelative(CGFloat)
        case `default`
    }
    
    public enum VerticalAlignment: Equatable {
        case center
        case `default`
    }
    
    internal var isEditingOrSelecting = false
    public var focusType: FocusType = FocusType.default
    public var verticalAlignment: VerticalAlignment = .center
    
  //  internal var isEditingHandler: ((Bool)->())? = nil

    public override func titleRect(forBounds rect: NSRect) -> NSRect {
        switch self.verticalAlignment {
        case .center:
            var titleRect = super.titleRect(forBounds: rect)
            let minimumHeight = self.cellSize(forBounds: rect).height
            titleRect.origin.y += (titleRect.size.height - minimumHeight) / 2
            titleRect.size.height = minimumHeight
            return titleRect
        case .default:
            return super.titleRect(forBounds: rect)
        }

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

#endif
