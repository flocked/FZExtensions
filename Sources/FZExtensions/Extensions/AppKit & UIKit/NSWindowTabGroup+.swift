//
//  File.swift
//  
//
//  Created by Florian Zand on 02.09.22.
//

#if os(macOS)

import Cocoa

public extension NSWindowTabGroup {
enum TabInsertionType {
        case before(NSWindow)
        case after  (NSWindow)
        case atStart
        case atEnd
        case afterCurrent
        case atIndex(Int)
    }
    
    func moveTabToNewWindow(_ tabWindow: NSWindow, makeKeyAndOrderFront: Bool) {
        if (self.windows.contains(tabWindow) && self.windows.count > 1) {
            self.removeWindow(tabWindow)
            var newFrame = self.windows.first?.frame ?? tabWindow.frame
            newFrame.origin = CGPoint(x: newFrame.origin.x + 10.0, y: newFrame.origin.y + 10.0)
            tabWindow.setFrame(newFrame, display: makeKeyAndOrderFront)
            if (makeKeyAndOrderFront) {
                tabWindow.makeKeyAndOrderFront(nil)
            }
        }
    }
    
    func insertWindow(_ window:NSWindow, _ insertionType: TabInsertionType = .atEnd) {
        switch insertionType {
        case .atStart:
            self.insertWindow(window, at: 0)
            case .atEnd:
                self.addWindow(window)
        case .before(let thisWindow):
            if let foundIndex = self.indexOfWindow(thisWindow) {
                self.insertWindow(window, at: foundIndex)
            } else {
                self.addWindow(window)
            }
        case .after(let thisWindow):
            if let foundIndex = self.indexOfWindow(thisWindow) {
                self.insertWindow(window, at: foundIndex+1)
            } else {
                self.addWindow(window)
            }
        case .atIndex(let index):
            if (index >= 0 && index <= self.windows.count) {
                self.insertWindow(window, at: index)
            }
        case .afterCurrent:
            if let index = self.indexOfSelectedTab {
                self.insertWindow(window, at: index + 1)
            }
        }
    }
    
    func indexOfWindow(_ window: NSWindow) -> Int? {
        return self.windows.firstIndex(of: window)
    }
    var indexOfSelectedTab: Int? {
        if let selectedWindow = selectedWindow {
         return self.indexOfWindow(selectedWindow)
        }
        return nil
    }
}

#endif
