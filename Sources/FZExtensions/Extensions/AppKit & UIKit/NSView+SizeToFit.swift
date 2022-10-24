//
//  File.swift
//  
//
//  Created by Florian Zand on 21.10.22.
//

#if os(macOS)
import AppKit
import SwiftUI
#elseif canImport(UIKit)
import UIKit
#endif

public protocol Sizable {
    func sizeThatFits(_ size: CGSize) -> CGSize
    var fittingSize: CGSize { get }
}

extension NSUIView: Sizable {

}

extension Sizable where Self: NSUIView {
   public func sizeToFit( size: CGSize) {
       self.frame.size = sizeThatFits(size)
    }
    
    public func sizeToFit() {
        self.frame.size = fittingSize
    }
    
    public func sizeToFit(width: CGFloat?, height: CGFloat?) {
        self.frame.size = self.sizeThatFits(width: width, height: height)
     }
    
    public func sizeThatFits(width: CGFloat?, height: CGFloat?) -> CGSize {
        return self.sizeThatFits(CGSize(width: width ?? NSUIView.noIntrinsicMetric, height: height ?? NSUIView.noIntrinsicMetric))
    }
}

#if os(macOS)
extension Sizable where Self: NSView {
   public func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.fittingSize
    }
}

extension NSHostingController: Sizable {
    public var fittingSize: CGSize {
        return view.fittingSize
    }
    
   public func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.sizeThatFits(in: size)
    }
    
    public func sizeToFit( size: CGSize) {
        self.view.frame.size = sizeThatFits(size)
     }
    
    public func sizeToFit() {
        self.view.frame.size = self.fittingSize
     }
}
#endif

#if canImport(UIKit)
extension Sizable where Self: NSUIView {
    public var fittingSize: CGSize {
        self.sizeThatFits(self.bounds.size)
    }
}
#endif
