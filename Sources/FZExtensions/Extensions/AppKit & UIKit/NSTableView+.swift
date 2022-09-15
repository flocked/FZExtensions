//
//  File.swift
//  
//
//  Created by Florian Zand on 09.09.22.
//

#if os(macOS)
import AppKit

extension NSTableView {
    public func reloadOnMainThread(_ complete: (() -> ())? = nil) {
        DispatchQueue.main.async {
            self.reloadData()
            complete?()
        }
    }
    
   public func reloadMaintainingSelection(_ complete: (() -> ())? = nil) {
          let oldSelectedRowIndexes = selectedRowIndexes
          reloadOnMainThread {
              if oldSelectedRowIndexes.count == 0 {
                  if self.numberOfRows > 0 {
                      self.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
                  }
              } else {
                  self.selectRowIndexes(oldSelectedRowIndexes, byExtendingSelection: false)
              }
          }
      }
    
    public static func tableRowHeight(text: ContentProperties.Text.FontSize, secondaryText: ContentProperties.Text.FontSize? = nil, textPadding: CGFloat = 0.0, verticalPadding: CGFloat = 2.0) -> CGFloat  {
       return self.tableRowHeight(fontSize: text.value, secondaryTextFontSize: secondaryText?.value, textPadding: textPadding, verticalPadding: verticalPadding)
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
}
#endif
