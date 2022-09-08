//
//  String+Height.swift
//  FZExtensions
//
//  Created by Florian Zand on 06.06.22.
//

#if os(macOS)
import AppKit

public extension String {
     func height(using width: CGFloat, font: NSFont, maxLines: Int? = nil) -> CGFloat {
        
         let textField = NSTextField()
         textField.preferredMaxLayoutWidth = width
         textField.font = font
         textField.stringValue = self
         textField.textLayout = .truncates
         textField.usesSingleLineMode = true
         textField.maximumNumberOfLines = 1
         if let maxLines = maxLines {
             if (maxLines > 1) {
                 textField.usesSingleLineMode = false
                 textField.maximumNumberOfLines = maxLines
                 textField.textLayout = .wraps
             }
         }
         
         textField.invalidateIntrinsicContentSize()
         return textField.intrinsicContentSize.height
         
         /*
        let maxSize = CGSize(width: width,
                             height: CGFloat.greatestFiniteMagnitude)
        
        let actualSize = self.boundingRect(with: maxSize,
                                           options: [.usesLineFragmentOrigin],
                                           attributes: [.font : font],
                                           context: nil)
        
        let height = ceil(actualSize.height)
         if let maxLines = maxLines {
             if (maxLines == 0) {
                 return 0.0
             } else if maxLines > 0 {
                      let lines = height / font.lineHeight
                      if lines >= maxLines {
                          return (actualSize.height / lines) * maxLines
                      }
             }
         }


         return height
*/
    }
}

public extension NSAttributedString {
    func height(using width: CGFloat, maxLines: Int? = nil) -> CGFloat {

        let textField = NSTextField()
        textField.preferredMaxLayoutWidth = width
        textField.attributedStringValue = self
        textField.textLayout = .truncates
        textField.usesSingleLineMode = true
        textField.maximumNumberOfLines = 1
        if let maxLines = maxLines {
            if (maxLines > 1) {
                textField.usesSingleLineMode = false
                textField.maximumNumberOfLines = maxLines
                textField.textLayout = .wraps
            }
        }
        
        textField.invalidateIntrinsicContentSize()
        return textField.intrinsicContentSize.height
        
        /*
        let maxSize = CGSize(width: width,
                             height: CGFloat.greatestFiniteMagnitude)
        
        let actualSize = self.boundingRect(with: maxSize,
                                           options: [.usesLineFragmentOrigin],
                                           context: nil)
        
        let height = ceil(actualSize.height)
         if let maxLines = maxLines {
             if (maxLines == 0) {
                 return 0.0
             } else if maxLines > 0 {
                      let lines = height / font.lineHeight
                      if lines >= maxLines {
                          return (actualSize.height / lines) * maxLines
                      }
             }
         }
        
        return height
        */
    }
}

#elseif canImport(UIKit)
import UIKit

public extension String {
     func height(using width: CGFloat, font: NSFont, maxLines: Int? = nil) -> CGFloat {
        
         let textField = UILabel()
         textField.font = font
         textField.text = self
         
         var numberOfLines = 1
         if let maxLines = maxLines, (maxLines > 1) {
             numberOfLines = maxLines
         }
         
         let rect = CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)
         let textRect = textField.textRect(forBounds: rect, limitedToNumberOfLines: rect)
         return textRect.height
    }
}

public extension NSAttributedString {
     func height(using width: CGFloat, maxLines: Int? = nil) -> CGFloat {
        
         let textField = UILabel()
         textField.font = font
         textField.attributedText = self
         
         var numberOfLines = 1
         if let maxLines = maxLines, (maxLines > 1) {
             numberOfLines = maxLines
         }
         
         let rect = CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)
         let textRect = textField.textRect(forBounds: rect, limitedToNumberOfLines: rect)
         return textRect.height
    }
}

#endif

