//
//  NSScrollView+.swift
//  FZCollection
//
//  Created by Florian Zand on 22.05.22.
//

#if os(macOS)

import Foundation
import AppKit

extension NSScrollView {
    var contentOffset: CGPoint {
        get {
        //    return contentView.bounds.origin
            return documentVisibleRect.origin
        }
        set {
            self.scroll(newValue)
        }
    }
    
    func scroll(_ point: CGPoint, animationDuration: CGFloat) {
        if (animationDuration > 0.0) {
            NSAnimationContext.runAnimationGroup({
                context in
                context.duration = animationDuration
                self.contentView.animator().setBoundsOrigin(point)
                self.reflectScrolledClipView(self.contentView)
            })
        } else {
            self.scroll(point)
        }
    }
    
    func scroll(_ rect: CGRect, animationDuration: CGFloat) {
        if (animationDuration > 0.0) {
            NSAnimationContext.runAnimationGroup({
                context in
                context.duration = animationDuration
                self.scrollToVisible(rect)
            })
        } else {
            self.scrollToVisible(rect)
        }
    }
    
    func setMagnification(_ magnification: CGFloat, animationDuration: CGFloat) {
        NSAnimationContext.runAnimationGroup({
            context in
            context.duration = animationDuration
            self.animator().magnification = magnification
        })
    }
    
}

#endif
