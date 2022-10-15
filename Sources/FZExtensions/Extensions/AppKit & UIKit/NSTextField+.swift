//
//  File.swift
//  
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)

import AppKit

public extension NSTextField {
    convenience init(layout: TextLayout) {
        self.init(frame: .zero)
        self.textLayout = layout
    }
    
    var truncatesLastVisibleLine: Bool {
        get { self.cell?.truncatesLastVisibleLine ?? false }
        set { self.cell?.truncatesLastVisibleLine = newValue }
    }
    
    convenience init(frame: CGRect, layout: TextLayout) {
        self.init(frame: frame)
        self.textLayout = layout
    }
    
    var textLayout: TextLayout? {
        get {
            switch (self.lineBreakMode, cell?.wraps, cell?.isScrollable) {
            case (.byWordWrapping, true, false):
                return .wraps
            case (.byTruncatingTail, false, false):
                return .truncates
            case (.byClipping, false, true):
                return .scrolls
            default:
                return nil
            }
        }
        set {
            if let newValue = newValue {
                self.lineBreakMode = newValue.lineBreakMode
                self.usesSingleLineMode = false
                self.cell?.wraps = newValue.wraps
                self.truncatesLastVisibleLine = true
                self.cell?.isScrollable = newValue.isScrollable
            }
        }
    }
    
    enum TextLayout: Int, CaseIterable {
        case truncates = 0
        case wraps = 1
        case scrolls = 2
        
        public init?(lineBreakMode: NSLineBreakMode) {
             guard let found = Self.allCases.first(where: {$0.lineBreakMode == lineBreakMode}) else { return nil  }
             self = found
        }
        
       internal var isScrollable: Bool {
            return (self == .scrolls)
        }
       internal var wraps: Bool {
            return (self == .wraps)
        }
       internal var lineBreakMode: NSLineBreakMode {
            switch self {
            case .wraps:
                return .byWordWrapping
            case .truncates:
                return .byTruncatingTail
            case .scrolls:
                return .byClipping
            }
        }
    }
    
    func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int
    ) -> CGRect {
        let _maximumNumberOfLines = self.maximumNumberOfLines
        self.maximumNumberOfLines = numberOfLines
        if let cell = self.cell {
            let rect = cell.drawingRect(forBounds: bounds)
            let cellSize = cell.cellSize(forBounds: rect)
            self.maximumNumberOfLines = _maximumNumberOfLines
            return CGRect(origin: .zero, size: cellSize)
        }
        self.maximumNumberOfLines = _maximumNumberOfLines
        return .zero
    }
    
    var isTruncatingText: Bool {
        var bounds = self.bounds
        let textSize = textRect(forBounds: bounds, limitedToNumberOfLines: self.maximumNumberOfLines).size
        bounds.size = CGSize(width: bounds.size.width, height: CGFloat.infinity)
        let fullSize = textRect(forBounds: bounds, limitedToNumberOfLines: 0).size
        return textSize != fullSize
    }
    
        enum LineOption {
            case all
            case limitToMaxNumberOfLines
        }
        
        func linesCount(_ optiom: LineOption = .limitToMaxNumberOfLines) -> Int {
            return self.rangesOfLines(optiom).count
        }
        
        func lines(_ option: LineOption = .limitToMaxNumberOfLines) -> [String] {
            let ranges = rangesOfLines(option)
            return ranges.compactMap({String(self.stringValue[$0])})
        }
        
        func rangesOfLines(_ option: LineOption = .limitToMaxNumberOfLines) -> [Range<String.Index>] {
            let stringValue = self.stringValue
            let linebreakMode = self.lineBreakMode
            if ((linebreakMode != .byCharWrapping || linebreakMode != .byWordWrapping) && self.maximumNumberOfLines != 1) {
                self.lineBreakMode = .byCharWrapping
            }
            var partialString: String = ""
            var startIndex = stringValue.startIndex
            var previousHeight: CGFloat = 0.0
            var didStart = false
            var nextIndex = stringValue.startIndex
            var lineRanges: [Range<String.Index>] = []
            var boundsSize = self.bounds.size
            boundsSize.height = .infinity
            stringValue.forEach({ char in
                partialString = partialString + String(char)
                self.stringValue = partialString
                let height = self.textRect(forBounds: CGRect(origin: .zero, size: boundsSize), limitedToNumberOfLines: option == .all ? 0 : self.maximumNumberOfLines + 1).size.height
                if (didStart == false) {
                    previousHeight = height
                    didStart = true
                } else {
                    nextIndex = stringValue.index(after: nextIndex)
                    if (height > previousHeight) {
                        let endIndex = nextIndex
                        let range = startIndex..<endIndex
                        startIndex = endIndex
                        lineRanges.append(range)
                        previousHeight = height
                    } else if (nextIndex == stringValue.index(before: stringValue.endIndex)) {
                        if (self.maximumNumberOfLines == 0 || option == .all || lineRanges.count < self.maximumNumberOfLines) {
                            let endIndex = stringValue.endIndex
                            let range = startIndex..<endIndex
                            lineRanges.append(range)
                        }
                    }
                }
            })
            self.stringValue = stringValue
            self.lineBreakMode = linebreakMode
            return lineRanges
        }
}

#endif

/*
 func textLines(width: CGFloat? = nil, numberOfLines: Int? = nil) -> [Range<String.Index>] {
     let stringValue = self.stringValue
     var partialString: String = ""
     var isBeginning = true
     var previousHeight: CGFloat = 0.0
     var lines: [Range<String.Index>] = []
     var line = 0
     var startIndex = stringValue.startIndex
     var maximumNumberOfLines = numberOfLines ?? self.maximumNumberOfLines
     if (maximumNumberOfLines > 0) {
         maximumNumberOfLines = maximumNumberOfLines + 1
     }
     let _maxNumberOfLines = self.maximumNumberOfLines
     let _lineBreakMode = self.lineBreakMode
     self.lineBreakMode = .byCharWrapping
     var nextIndex = stringValue.startIndex
     let width = width ?? self.bounds.size.width
     self.maximumNumberOfLines = maximumNumberOfLines
     stringValue.forEach({
         char in
         if (nextIndex != stringValue.endIndex) {
             nextIndex = stringValue.index(after: nextIndex)
         }
         partialString = partialString + String(char)
         self.stringValue = partialString
         let fittingSize = self.sizeThatFits(CGSize(width, .infinity))
         if (isBeginning) {
             nextIndex = stringValue.startIndex
             previousHeight = fittingSize.height
             isBeginning = false
         } else {
             if (fittingSize.height > previousHeight) {
                 let endIndex = nextIndex
                 let lineString = String(stringValue[startIndex..<endIndex])
                 startIndex = endIndex
                 var range = startIndex..<endIndex
                 lines.append(range)
                 Swift.print(line, lineString)
             //    lines[line] = lineString
                 previousHeight = fittingSize.height
                 line = line + 1
             } else {
                 if (nextIndex == stringValue.index(before: stringValue.endIndex) && (line < _maxNumberOfLines || self.maximumNumberOfLines == 0)) {
                     let endIndex = stringValue.endIndex
                     let lineString = String(stringValue[startIndex..<endIndex])
                     var range = startIndex..<endIndex
                     lines.append(range)
                  //   lines[line] = lineString
                 }
             }
         }
     })
     self.stringValue = stringValue
     self.maximumNumberOfLines = _maxNumberOfLines
     self.lineBreakMode = _lineBreakMode
     return lines
 }
 */
