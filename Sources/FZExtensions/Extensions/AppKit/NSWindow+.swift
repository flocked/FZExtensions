//
//  NSWindow+.swift
//  FZExtensions
//
//  Created by Florian Zand on 12.08.22.
//

#if os(macOS)

import Cocoa

public extension NSWindow {
    var isFullscreen: Bool {
        styleMask.contains(.fullScreen)
    }
    
    /// Make the receiver a sensible size, given the current screen
    ///
    /// This method attempts to size the window to match the current screen
    /// aspect ratio and dimensions. It will not exceed 1024 x 900.
     func resizeToScreenAspectRatio() {
        guard let screen = NSScreen.main else {
            return
        }
        let aspectRatio = screen.visibleFrame.size.aspectRatio
        var newSize = self.frame.size
        newSize.width = self.frame.height * aspectRatio
        if (newSize.width < self.minSize.width) {
            newSize.width = self.minSize.width
        //    newSize.height =
        }
        
        /*
        let minWindowSize = NSSize(width: 800, height: 600)
        let maxWindowSize = NSSize(width: 1024, height: 900)
        let fraction: CGFloat = 0.6

        let screenSize = NSScreen.main?.visibleFrame.size ?? minWindowSize

        
        screenSize.aspectRatio
        
        let width = min(screenSize.width * fraction, maxWindowSize.width)
        let height = min(screenSize.height * fraction, maxWindowSize.height)

        setContentSize(NSSize(width: ceil(width), height: ceil(height)))
         */
    }
    
    /// Returns the total titlebar height
    ///
    /// Takes into account the tab bar, as well as transparent title bars and
    /// full size content.
     var titleBarHeight: CGFloat {
        let frameHeight = contentView?.frame.height ?? frame.height
        let contentLayoutRectHeight = contentLayoutRect.height

        return frameHeight - contentLayoutRectHeight
    }
    
    /// Indicates the state of the window's tab bar
     var isTabBarVisible: Bool {
        if #available(OSX 10.13, *) {
            // be extremely careful here. Just *accessing* the tabGroup property can
            // affect NSWindow's tabbing behavior
            if tabbedWindows == nil {
                return false
            }
            
            return tabGroup?.isTabBarVisible ?? false
        } else {
            return false
        }
    }
    
    /// Returns the tab bar height
    ///
    /// This value will be zero if the tab bar is not visible
     var tabBarHeight: CGFloat {
        // hard-coding this isn't excellent, but I don't know
        // of another way to determine it without messing around
        // with hidden windows.
        return isTabBarVisible ? 28.0 : 0.0
    }
    
     func withAnimationDisabled(block: () -> Void) {
        let currentBehavior = animationBehavior

        animationBehavior = .none

        block()

        OperationQueue.main.addOperation {
            self.animationBehavior = currentBehavior
        }
    }
}

#endif
