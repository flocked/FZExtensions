//
//  File.swift
//  
//
//  Created by Florian Zand on 15.09.22.
//


#if os(macOS)

import AppKit

extension NSToolbarItem.Identifier: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

public extension NSToolbarItem {
     static func segmented(_ itemIdentifier: NSToolbarItem.Identifier, segmented: NSSegmentedControl, title: String) -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier, segmented: segmented, title: title)
    }
    
    static func segmented(_ itemIdentifier: NSToolbarItem.Identifier, segments: [NSSegmentedControl.Segment], mode: NSSegmentedControl.SwitchTracking = .selectOne, title: String, selector: Selector) -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier, segments: segments, mode: mode, title: title, selector: selector)
   }
    
    static func view(_ itemIdentifier: NSToolbarItem.Identifier, view: NSView, title: String) -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier, view: view, title: title)
    }
    
    static func search(_ itemIdentifier: NSToolbarItem.Identifier, delegate: NSSearchFieldDelegate, title: String) -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier, searchfieldDelegate: delegate, title: title)
    }
    
    static func button(_ itemIdentifier: NSToolbarItem.Identifier, title: String, image: NSImage? = nil, selector: Selector) -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier, title: title, image: image, selector: selector)
    }
    
    static func onOffButton(_ itemIdentifier: NSToolbarItem.Identifier, isOff: Bool, values: (String?, NSImage?), alternatingValues: (String?, NSImage?)?, title: String, image: NSImage? = nil, selector: Selector) -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier, type: .onOff, isOff: isOff, values: values, alternatingValues: alternatingValues, title: title, selector: selector)
    }
    
    static func checkboxButton(_ itemIdentifier: NSToolbarItem.Identifier, isOff: Bool, values: (String?, NSImage?), alternatingValues: (String?, NSImage?)?, title: String, image: NSImage? = nil, selector: Selector) -> NSToolbarItem {
        return NSToolbarItem(itemIdentifier, type: .switch, isOff: isOff, values: values, alternatingValues: alternatingValues, title: title, selector: selector)
    }
    
    convenience init(_ itemIdentifier: NSToolbarItem.Identifier, view: NSView, title: String) {
        self.init(itemIdentifier: itemIdentifier)
        self.autovalidates = true
        self.maxSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        self.view = view
        self.toolTip = title
        self.label = title
    }
    
    convenience init(_ itemIdentifier: NSToolbarItem.Identifier, segmented: NSSegmentedControl, title: String) {
        self.init(itemIdentifier: itemIdentifier)
        self.autovalidates = true
        self.view = segmented
        self.toolTip = title
        self.label = title
    }
    
    convenience init(_ itemIdentifier: NSToolbarItem.Identifier, segments: [NSSegmentedControl.Segment], mode: NSSegmentedControl.SwitchTracking = .selectOne, title: String, selector: Selector) {
        let segmentedControl = NSSegmentedControl(segments: segments)
        segmentedControl.trackingMode = mode
        segmentedControl.action = selector
        self.init(itemIdentifier, view: segmentedControl, title: title)
    }
    
    convenience init(_ itemIdentifier: NSToolbarItem.Identifier, searchfieldDelegate: NSSearchFieldDelegate, title: String) {
        let searchField = NSSearchField()
        searchField.delegate = searchfieldDelegate
        searchField.frame.size = CGSize(160, searchField.frame.size.height)
        self.init( itemIdentifier, view: searchField, title: title)
    }
    
    convenience init(_ itemIdentifier: NSToolbarItem.Identifier, title: String, image: NSImage? = nil, selector: Selector) {
        self.init(itemIdentifier: itemIdentifier)
        self.autovalidates = true
        self.toolTip = title
        self.label = title
        let button = NSButton()
        button.bezelStyle = .texturedRounded
        button.image = image
        if (image == nil) {
            button.title = title
        }
        button.imageScaling = .scaleProportionallyDown
        button.action = selector
        self.view = button
    }
    
    convenience init(_ itemIdentifier: NSToolbarItem.Identifier, type: NSButton.ButtonType, isOff: Bool, values: (String?, NSImage?), alternatingValues: (String?, NSImage?)?, title: String, selector: Selector) {
        self.init(itemIdentifier: itemIdentifier)
        self.autovalidates = true
        self.toolTip = title
        self.label = title
        let button = NSButton()
        button.bezelStyle = .texturedRounded
        button.setButtonType(type)
        button.image = values.1
        button.state = (isOff == false) ? .on : .off
        button.alternateImage = alternatingValues?.1
        button.title = values.0 ?? ""
        button.alternateTitle = alternatingValues?.0 ?? ""
        button.imageScaling = .scaleProportionallyDown
        button.action = selector
        self.view = button
    }
    
}

#endif
