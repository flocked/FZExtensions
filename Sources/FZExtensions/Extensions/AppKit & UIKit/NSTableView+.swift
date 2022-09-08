//
//  File.swift
//  
//
//  Created by Florian Zand on 09.09.22.
//

#if os(macOS)
import AppKit

public extension NSTableView {
    static func tableRowHeight(rowSizeStyle: NSTableView.RowSizeStyle, verticalPadding: CGFloat = 2.0) -> CGFloat  {
        let textFieldFontSize: CGFloat
        switch rowSizeStyle {
        case .small: textFieldFontSize = 11
        case .large:
            if #available(macOS 11.0, *) {
                textFieldFontSize = 15
            } else {
                textFieldFontSize = 13
            }
        default: textFieldFontSize = 13
        }
        return self.tableRowHeight(systemFontSize: textFieldFontSize, verticalPadding: verticalPadding)
    }
    
    static func tableRowHeight(systemFontSize: CGFloat, verticalPadding: CGFloat = 2.0) -> CGFloat  {
        let textField = NSTextField()
        
        textField.font = .systemFont(ofSize: systemFontSize)
        textField.stringValue = " "
        textField.isBezeled = false
        textField.isEditable = false
        textField.isSelectable = false
        textField.drawsBackground = false
        textField.usesSingleLineMode = true
        
        textField.maximumNumberOfLines = 1
        textField.lineBreakMode = .byTruncatingTail
        
        return textField.fittingSize.height + (2.0 * verticalPadding)
    }
    
    static func tableRowHeight(controlSize: NSControl.ControlSize, verticalPadding: CGFloat = 2.0) -> CGFloat  {
        let textFieldFontSize:CGFloat = NSFont.systemFontSize(for: controlSize)
        return self.tableRowHeight(systemFontSize: textFieldFontSize, verticalPadding: verticalPadding)
    }
}
#endif
