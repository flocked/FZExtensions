//
//  NSScreen+Extension.swift
//  Resizer
//
//  Created by Florian Zand on 10.07.22.
//  Copyright © 2022 MuffinStory. All rights reserved.
//

#if os(macOS)

import Cocoa
import CoreGraphics


public extension NSScreen {
    var displayID: CGDirectDisplayID {
      let key = NSDeviceDescriptionKey(rawValue: "NSScreenNumber")
      return deviceDescription[key] as? CGDirectDisplayID ?? 0
    }
    
    var orderedIndex: Int? {
        let screens = NSScreen.screens.sorted { $0.frame.minX < $1.frame.minX }
        return screens.firstIndex(of: self)
    }
    
    var quartzFrame: CGRect {
        return CGDisplayBounds(self.displayID)
    }
    
    class var screenWithMouse: NSScreen? {
     let mouseLocation = NSEvent.mouseLocation
     let screens = NSScreen.screens
     let screenWithMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })
     return screenWithMouse
    }
    
    static var airplay: NSScreen? {
      return NSScreen.screens.first(where: {$0.localizedName.lowercased().contains("airplay")})
    }
    
    static var builtIn: NSScreen? {
      return NSScreen.screens.first(where: {CGDisplayIsBuiltin($0.displayID) != 0})
    }
    
    var isVirtual: Bool {
        var isVirtual: Bool = false
        let name = self.localizedName
        if name.contains("dummy") || name.contains("airplay") || name.contains("sidecar") {
          isVirtual = true
        }
        return isVirtual
    }
    
    static func screen(at point:NSPoint) -> NSScreen? {
        var returnScreen:NSScreen? = nil
        let screens = NSScreen.screens
            for screen in screens {
                if NSMouseInRect(point, screen.frame, false) {
                    returnScreen = screen
                }
            }
        return returnScreen
    }
    
    /*
    var isVirtual: Bool {
        var isVirtual = false
        if !DEBUG_MACOS10, #available(macOS 11.0, *) {
            if let dictionary = (CoreDisplay_DisplayCreateInfoDictionary(self.displayID)?.takeRetainedValue() as NSDictionary?) {
            let isVirtualDevice = dictionary["kCGDisplayIsVirtualDevice"] as? Bool
            let displayIsAirplay = dictionary["kCGDisplayIsAirPlay"] as? Bool
            if isVirtualDevice ?? displayIsAirplay ?? false {
              isVirtual = true
            }
          }
        }
        return isVirtual
    }
    */
    
}

#endif
