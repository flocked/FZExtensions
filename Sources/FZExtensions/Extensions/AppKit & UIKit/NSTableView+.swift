//
//  File.swift
//  
//
//  Created by Florian Zand on 09.09.22.
//

#if os(macOS)
import AppKit

extension NSTableView {
    public func reloadOnMainThread(completionHandler: (() -> ())? = nil) {
        DispatchQueue.main.async {
            self.reloadData()
            completionHandler?()
        }
    }
    
    public var nonSelectedRowIndexes: IndexSet {
        let selected = self.selectedRowIndexes
        var nonSelectedRowIndexes = IndexSet()
        for i in 0..<self.numberOfRows {
            if (selected.contains(i) == false) {
                nonSelectedRowIndexes.insert(i)
            }
         }
        return nonSelectedRowIndexes
    }
    
    public func visibleRowIndexes() -> [Int] {
        let visibleRects = self.visibleRect
        let visibleRange = self.rows(in: visibleRects)
        var rows = [Int]()
        for i in visibleRange.location...visibleRange.location+visibleRange.length {
            rows.append(i)
        }
        return rows
    }
    
    public func visibleRows(makeIfNecessary: Bool) -> [NSTableRowView] {
        return self.visibleRowIndexes().compactMap({self.rowView(atRow: $0, makeIfNecessary: makeIfNecessary)})
    }
    
    public func visibleCells(for columns: [NSTableColumn], makeIfNecessary: Bool) -> [NSTableCellView] {
        let rowIndexes = self.visibleRowIndexes()
        let tableColumnsCount = self.tableColumns.count
        var cells = [NSTableCellView]()
        var columnIndexes = [Int]()
        for (index, column) in self.tableColumns.enumerated() {
            if (columns.contains(column)) {
                columnIndexes.append(index)
            }
        }
        
        for columnIndex in columnIndexes {
            for rowIndex in rowIndexes {
                if let cellView = self.view(atColumn: columnIndex, row: rowIndex, makeIfNecessary: makeIfNecessary) as? NSTableCellView {
                    cells.append(cellView)
                }
            }
        }
        return cells
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
