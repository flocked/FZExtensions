//
//  File.swift
//  
//
//  Created by Florian Zand on 09.09.22.
//

#if os(macOS)
import AppKit

extension NSTableView {
    /*
     public static func tableRowHeight(rowSize: NSTableView.RowSizeStyle, secondaryRowSize: NSTableView.RowSizeStyle? = nil, textPadding: CGFloat = 0.0, verticalPadding: CGFloat = 2.0) -> CGFloat  {
        var secondaryFontSize: CGFloat? = nil
        if let secondaryRowSize = secondaryRowSize {
            secondaryFontSize = NSFont.systemFontSize(for: secondaryRowSize)
        }
        return self.tableRowHeight(fontSize: NSFont.systemFontSize(for: controlSize), secondaryTextFontSize: secondaryFontSize, textPadding: textPadding, verticalPadding: verticalPadding)
    }
    
     public static func tableRowHeight(controlSize: NSControl.ControlSize, secondaryControlSize: NSControl.ControlSize? = nil, textPadding: CGFloat = 0.0, verticalPadding: CGFloat = 2.0) -> CGFloat  {
        var secondaryFontSize: CGFloat? = nil
        if let secondaryControlSize = secondaryControlSize {
            secondaryFontSize = NSFont.systemFontSize(for: secondaryControlSize)
        }
        return self.tableRowHeight(fontSize: NSFont.systemFontSize(for: controlSize), secondaryTextFontSize: secondaryFontSize, textPadding: textPadding, verticalPadding: verticalPadding)
    }
     */
    
   public static func tableRowHeight(text: RowTextConfiguration, secondaryText: RowTextConfiguration? = nil, textPadding: CGFloat = 0.0, verticalPadding: CGFloat = 2.0) -> CGFloat  {
       return self.tableRowHeight(fontSize: text.fontSize, secondaryTextFontSize: secondaryText?.fontSize, textPadding: textPadding, verticalPadding: verticalPadding)
    }
    
    public static func tableRowHeight(fontSize: CGFloat, secondaryTextFontSize: CGFloat? = nil, textPadding: CGFloat = 0.0, verticalPadding: CGFloat = 2.0) -> CGFloat  {
        let textField = NSTextField()
        
        textField.font = .systemFont(ofSize: fontSize)
        textField.stringValue = " "
        textField.isBezeled = false
        textField.isEditable = false
        textField.isSelectable = false
        textField.drawsBackground = false
        textField.usesSingleLineMode = true
        
        textField.maximumNumberOfLines = 1
        textField.lineBreakMode = .byTruncatingTail
        
        var height = textField.fittingSize.height + (2.0 * verticalPadding)
        if let secondaryTextFontSize = secondaryTextFontSize {
            height = height + self.tableRowHeight(fontSize: secondaryTextFontSize, textPadding: 0.0, verticalPadding: 0.0) + textPadding
        }
        return height
    }
    
    public enum RowTextConfiguration {
         case fontSize(CGFloat)
         case controlSize(NSControl.ControlSize)
         case rowSize(NSTableView.RowSizeStyle)
        internal var fontSize: CGFloat {
             switch self {
             case .fontSize(let value):
                 return value
             case .controlSize(let value):
                 return NSFont.systemFontSize(for: value)
             case .rowSize(let value):
                 return NSFont.systemFontSize(for: value)
             }
         }
     }
    
}
#endif
