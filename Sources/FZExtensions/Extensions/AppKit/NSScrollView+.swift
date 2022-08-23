//
//  NSScrollView+.swift
//  FZCollection
//
//  Created by Florian Zand on 22.05.22.
//

#if os(macOS)

import Foundation
import AppKit

public extension NSScrollView {
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
        
    func setMagnification(_ magnification: CGFloat, centeredAt: CGPoint? = nil, animationDuration: TimeInterval?) {
        if let animationDuration = animationDuration, animationDuration != 0.0 {
        NSAnimationContext.runAnimationGroup({
            context in
            context.duration = animationDuration
            if let centeredAt = centeredAt {
                self.scroll(centeredAt, animationDuration: animationDuration)
            }
            self.animator().magnification = magnification
        }) } else {
            if let centeredAt = centeredAt {
                self.setMagnification(magnification, centeredAt: centeredAt)
            } else {
                self.magnification = magnification
            }
        }
    }
    
}

public extension NSCollectionView {
    struct SavedScrollPosition {
        let bounds: CGRect
        let visible: CGRect
    }
    func saveScrollPosition() -> SavedScrollPosition {
        return SavedScrollPosition(bounds: bounds, visible: visibleRect)
    }

    func restoreScrollPosition(_ saved: SavedScrollPosition) {
        let oldBounds = saved.bounds
        let oldVisible = saved.visible
        let oldY = oldVisible.midY
        let oldH = oldBounds.height
        guard oldH > 0.0 else { return }

        let fraction = (oldY - oldBounds.minY) / oldH
        let newBounds = self.bounds
        var newVisible = self.visibleRect
        let newY = newBounds.minY + fraction * newBounds.height
        newVisible.origin.y = newY - 0.5 * newVisible.height
        self.scroll(newVisible.origin)
    }
}

#endif
