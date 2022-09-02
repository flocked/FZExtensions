//
//  NSPopupButton.swift
//  FZCollection
//
//  Created by Florian Zand on 29.05.22.
//

#if os(macOS)
import Foundation
import AppKit

public extension NSPopUpButton {
    convenience init(items: [NSMenuItem]) {
        self.init()
        self.items = items
    }
    
    convenience init(titles: [String]) {
        self.init()
        self.items = titles.compactMap({NSMenuItem($0)})
    }
    
var items: [NSMenuItem] {
        get {
            return self.menu?.items ?? []
        }
        set {
            if let menu = menu {
                let selectedItemTitle = self.titleOfSelectedItem
                menu.items = newValue
                if let selectedItemTitle = selectedItemTitle, let item = newValue.first(where: {$0.title == selectedItemTitle}) {
                    self.select(item)
                }
            } else {
                self.menu = NSMenu(items: newValue)
            }
        }
    }
}
#endif
