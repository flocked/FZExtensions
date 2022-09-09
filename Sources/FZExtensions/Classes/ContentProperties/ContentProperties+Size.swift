//
//  File.swift
//  
//
//  Created by Florian Zand on 09.09.22.
//

import Foundation
extension ContentProperties {
    public struct Size {
        internal var option: SizeOption = .size
        public var value: CGSize
        public var resizing: Option = .resizing
        
        internal init(value: CGSize, resizeBy option: Option) {
            self.option = .size
            self.value = value
            self.resizing = option
        }
        
        internal init(option: SizeOption, value: CGSize, resizing: Option) {
            self.option = option
            self.value = value
            self.resizing = resizing
        }
        
        public static func min(size: CGSize, resizing option: Option) -> Self {
           return self.init(option: .min, value: size, resizing: option)
        }
        
        public static func min(width: CGFloat, resizing option: Option) -> Self {
            return self.init(option: .min, value: CGSize(width: width, height: .infinity), resizing: option)
        }
        
        public static func min(height: CGFloat, resizing option: Option) -> Self {
            return self.init(option: .min, value: CGSize(width: .infinity, height: height), resizing: option)
        }
        
        public static func max(size: CGSize, resizing option: Option) -> Self {
          return self.init(option: .min, value: size, resizing: option)
        }
        
        public static func max(width: CGFloat, resizing option: Option) -> Self {
            return self.init(option: .max, value: CGSize(width: width, height: .infinity), resizing: option)
        }
        
        public static func max(height: CGFloat, resizing option: Option) -> Self {
            return self.init(option: .max, value: CGSize(width: .infinity, height: height), resizing: option)
        }
        
        internal enum SizeOption {
             case min
             case max
             case size
         }
        
    
       public enum SizeValue {
            case size(CGSize)
            case width(CGFloat)
            case height(CGFloat)
        }
        
        public enum Option {
            case scaledToFill
             case scaledToFit
            case scaledToFitWidth
            case scaledToFitHeight
             case resizing
         }
        
    }
}

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension NSUIView {
    func configurate(using sizeProperty: ContentProperties.Size) {
        var size = sizeProperty.value
        if (size.width == .infinity) {
            size.width = self.frame.width
        }
        if (size.height == .infinity) {
            size.height = self.frame.height
        }
        
        var shouldResize = false
        switch sizeProperty.option {
        case .min:
            shouldResize = (self.frame.size.width < size.width || self.frame.size.height < size.height)
        case .max:
            shouldResize = (self.frame.size.width > size.width || self.frame.size.height > size.height)
        case .size:
            shouldResize = true
        }
        
        if (shouldResize == true) {
            switch sizeProperty.resizing {
            case .scaledToFill:
                self.frame = self.frame.scaled(toFill: size)
            case .scaledToFit:
                self.frame = self.frame.scaled(toFit: size)
            case .resizing:
                self.frame = self.frame.scaled(toFit: size)
            case .scaledToFitWidth:
                self.frame = self.frame.scaled(toWidth: size.width)
            case .scaledToFitHeight:
                self.frame = self.frame.scaled(toHeight: size.height)
            }
        }
    }
}
