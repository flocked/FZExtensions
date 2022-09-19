//
//  Fitting.swift
//  TokenView
//
//  Created by Florian Zand on 18.05.22.
//

#if os(macOS)

import Foundation
import AppKit

public class ResizingTextField: NSTextField, NSTextFieldDelegate {
    public enum EditState {
        case didBegin
        case didEnd
        case changed
    }
    
    public var editingStateHandler: ((EditState)->Void)?
    
    /*
    override func becomeFirstResponder() -> Bool {
        let textView = window?.fieldEditor(true, for: nil) as? NSTextView
        textView?.insertionPointColor = .yellow
        return super.becomeFirstResponder()
    }
    */
    
   private func isConforming(_ string: String) -> Bool {
            if (string == "" && allowsEmptyString == false) {
                return false
            } else if let minimumChars = self.minAmountChars, string.count < minimumChars {
                return false
            } else if let maxAmountChars = self.maxAmountChars, string.count > maxAmountChars {
                return false
            }
        return true
    }
    
    public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            if (isConforming(stringValue)) {
                self.window?.makeFirstResponder(nil)
            } else {
                NSSound.beep()
            }
        } else if commandSelector == #selector(NSResponder.cancelOperation(_:)) {
            self.isEditing = false
            self.stringValue = self.previousStringValue
            self.window?.makeFirstResponder(nil)
            self.invalidateIntrinsicContentSize()
            return true
        }
        return false
    }
   
   private(set) var isEditing = false

   private var placeholderSize: NSSize? { didSet {
       if let placeholderSize_ = placeholderSize {
           placeholderSize = NSSize(width: ceil(placeholderSize_.width), height: ceil(placeholderSize_.height))
       }
   }}
   private var lastContentSize = NSSize() { didSet {
       lastContentSize = NSSize(width: ceil(self.lastContentSize.width), height: ceil(self.lastContentSize.height))
   }}
   
   override init(frame frameRect: NSRect) {
       super.init(frame: frameRect)
       _init()
   }
   
   required init?(coder: NSCoder) {
       super.init(coder: coder)
       _init()
   }
   
   private func _init() {
       // Receive text change notifications during Japanese input conversion (while `marked text` is present).
       (self.cell as? NSTextFieldCell)?.setWantsNotificationForMarkedText(true)
       self.translatesAutoresizingMaskIntoConstraints = false
       self.delegate = self
       #if DEBUG
       //self.wantsLayer = true
       //self.layer?.setBorder(with: NSColor.red.cgColor)
       #endif
   }
   
   public override func awakeFromNib() {
       super.awakeFromNib()
       
       // If you use `.byClipping`, the width calculation does not seem to be done correctly.
       self.cell?.isScrollable = true
       self.cell?.wraps = true
       self.lineBreakMode = .byTruncatingTail
       
       self.lastContentSize = size(self.stringValue)
       if let placeholderString = self.placeholderString {
           self.placeholderSize = size(placeholderString)
       }
   }
    
    public var allowsEmptyString: Bool = false
    public var minAmountChars: Int? = nil
    public var maxAmountChars: Int? = nil
    public var maxWidth: CGFloat? = nil

   
   public override var placeholderString: String? { didSet {
       guard let placeholderString = self.placeholderString else { return }
       var size = size(placeholderString)
       size.width = size.width + 8.0
       self.placeholderSize = size
   }}
   
   public override var stringValue: String { didSet {
       if self.isEditing {return}
       self.lastContentSize = size(stringValue)
   }}
    
    public  override var font: NSFont? {
        didSet {
            if self.isEditing {return}
            self.lastContentSize = size(stringValue)
        }
    }
   
   private func size(_ string: String) -> NSSize {
       let font = self.font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize, weight: .regular)
       let stringSize = NSAttributedString(string: string, attributes: [.font : font]).size()
       
       return NSSize(width: stringSize.width, height: super.intrinsicContentSize.height)
   }
   
    
    private var previousStringValue: String = ""
    private var previousCharStringValue: String = ""
    private var previousSelectedRange: NSRange? = nil

   public override func textDidBeginEditing(_ notification: Notification) {
       super.textDidBeginEditing(notification)
       self.isEditing = true
       self.previousStringValue = self.stringValue
       self.previousCharStringValue = self.stringValue
       self.previousSelectedRange = self.editingSelectedRange
       // This is a tweak to fix the problem of insertion points being drawn at the wrong position.
       if let fieldEditor = self.window?.fieldEditor(false, for: self) as? NSTextView {
           fieldEditor.insertionPointColor = NSColor.clear
       }
       self.editingStateHandler?(.didBegin)
   }
   
   public override func textDidEndEditing(_ notification: Notification) {
       super.textDidEndEditing(notification)
       self.isEditing = false
       self.editingStateHandler?(.didEnd)
   }
    
    var editingCursorLocation: Int? {
        let currentEditor = self.currentEditor() as? NSTextView
       return currentEditor?.selectedRanges.first?.rangeValue.location
    }
    
    var editingSelectedRange: NSRange? {
        get {
        let currentEditor = self.currentEditor() as? NSTextView
            return currentEditor?.selectedRanges.first?.rangeValue
        }
        set {
            if let range = newValue {
            let currentEditor = self.currentEditor() as? NSTextView
            currentEditor?.setSelectedRange(range)
            }
        }
    }
   
   public override func textDidChange(_ notification: Notification) {
       super.textDidChange(notification)
       if let minAmountChars = minAmountChars, self.stringValue.count < minAmountChars {
           if (previousStringValue.count > self.stringValue.count) {
               self.stringValue = previousStringValue
               self.editingSelectedRange = self.previousSelectedRange
           }
       } else if let maxAmountChars = maxAmountChars, self.stringValue.count > maxAmountChars {
           if (previousStringValue.count < self.stringValue.count) {
               self.stringValue = previousStringValue
               self.editingSelectedRange = self.previousSelectedRange
           }
       }
    //   self.previousStringValue = self.stringValue
       self.previousSelectedRange = self.editingSelectedRange
       
       self.invalidateIntrinsicContentSize()
       self.editingStateHandler?(.changed)
   }
   
    public var shouldAutoSize: Bool = true
    
    public override var intrinsicContentSize: NSSize {
       let intrinsicContentSize = super.intrinsicContentSize
       if (shouldAutoSize == false) {
           return intrinsicContentSize
       }
       
       let minWidth: CGFloat!
       if !self.stringValue.isEmpty {
           minWidth = self.lastContentSize.width
       }
       else {
           minWidth = ceil(self.placeholderSize?.width ?? 0)
       }
       
       var minSize = NSSize(width: minWidth, height: intrinsicContentSize.height)
       if let maxWidth = maxWidth, minSize.width >= maxWidth {
           if let cellSize = cell?.cellSize(forBounds: NSRect(x: 0, y: 0, width: maxWidth, height: 1000)) {
               minSize.height = cellSize.height + 8.0
           }
           minSize.width = maxWidth

       }
       
       guard let fieldEditor = self.window?.fieldEditor(false, for: self) as? NSTextView
       else {
           return minSize
       }
       
       fieldEditor.insertionPointColor = self.textColor ?? NSColor.textColor
       
       if !self.isEditing {
           return minSize
       }
              
       if fieldEditor.string.isEmpty {
           self.lastContentSize = minSize
           return minSize
       }
       
       // This is a tweak to fix the problem of insertion points being drawn at the wrong position.
       let newWidth = ceil(size(self.stringValue).width)
       var newSize = NSSize(width: newWidth, height: intrinsicContentSize.height)
       if let maxWidth = maxWidth, newSize.width >= maxWidth {
           if let cellSize = cell?.cellSize(forBounds: NSRect(x: 0, y: 0, width: maxWidth, height: 1000)) {
               newSize.height = cellSize.height + 8.0
           }
           newSize.width = maxWidth
       }
       self.lastContentSize = newSize
       return newSize
   }
}

#endif
