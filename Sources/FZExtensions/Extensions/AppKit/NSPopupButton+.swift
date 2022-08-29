//
//  NSPopupButton.swift
//  FZCollection
//
//  Created by Florian Zand on 29.05.22.
//

import Foundation
import AppKit

protocol Option: CaseIterable, RawRepresentable {
    var rawValue: String {get}
}



enum Haha: String, Option {
    case fun
}

extension NSPopUpButton {
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
