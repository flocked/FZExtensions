//
//  String+Height.swift
//  FZExtensions
//
//  Created by Florian Zand on 06.06.22.
//
import Foundation

public extension NSAttributedString {
     func height(using width: CGFloat) -> CGFloat {
        
        let maxSize = CGSize(width: width,
                             height: CGFloat.greatestFiniteMagnitude)
        
        let actualSize = boundingRect(with: maxSize,
                                      options: [.usesLineFragmentOrigin],
                                      context: nil)
        return actualSize.height
    }
}


#if os(macOS)
import AppKit

public extension String {
     func height(using width: CGFloat, font: NSFont, maxLines: CGFloat = 0) -> CGFloat {
        
        let maxSize = CGSize(width: width,
                             height: CGFloat.greatestFiniteMagnitude)
        
        let actualSize = self.boundingRect(with: maxSize,
                                           options: [.usesLineFragmentOrigin],
                                           attributes: [.font : font],
                                           context: nil)
        
        let height = ceil(actualSize.height)
        if maxLines > 0 {
             let lines = height / font.lineHeight

             if lines >= maxLines {
                 return (actualSize.height / lines) * maxLines
             }

         }

         return height

    }
}

#endif
