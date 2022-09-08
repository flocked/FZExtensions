//
//  GlobalEventMonitor.swift
//  Resizer
//
//  Created by Florian Zand on 08.09.22.
//  Copyright © 2022 MuffinStory. All rights reserved.
//

#if os(macOS)
import AppKit

public extension NSEvent {    
     class Monitor {
        private var monitor: Any?
        private let mask: NSEvent.EventTypeMask
        private let type: MonitorType
        
        public var handler: ((NSEvent?) ->())
        
        public enum MonitorType {
            case global
            case local
        }

        public init(mask: NSEvent.EventTypeMask, type: MonitorType = .global, handler: @escaping ((NSEvent?) ->())) {
            self.mask = mask
            self.handler = handler
            self.type = type
        }
        
        public static func keyDown(type: MonitorType = .global, handler: @escaping ((NSEvent?) ->())) -> Monitor {
            return Monitor(mask: .keyDown, type: type, handler: handler)
        }
        
        public static func mouseMoved(type: MonitorType = .global, handler: @escaping ((NSEvent?) ->())) -> Monitor {
            return Monitor(mask: .mouseMoved, type: type, handler: handler)
        }
        
        public static func leftMouseDown(type: MonitorType = .global, handler: @escaping ((NSEvent?) ->())) -> Monitor {
            return Monitor(mask: .leftMouseDown, type: type, handler: handler)
        }
        
        public static func rightMouseDown(type: MonitorType = .global, handler: @escaping ((NSEvent?) ->())) -> Monitor {
            return Monitor(mask: .rightMouseDown, type: type, handler: handler)
        }

        deinit {
            stop()
        }
        
        private func internalHandler(_ event: NSEvent?) {
            self.handler(event)
        }
        
        private func internalLocalHandler(_ event: NSEvent) -> NSEvent? {
            self.handler(event)
            return event
        }
        
        private var isRunning: Bool {
            return (monitor != nil)
        }
        
        public func start() {
            if isRunning == false {
            switch self.type {
            case .global:
                self.monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: self.internalHandler)
            case .local:
                self.monitor = NSEvent.addLocalMonitorForEvents(matching: mask, handler: self.internalLocalHandler)
            }
            }
        }

        public func stop() {
            if isRunning, let monitor = self.monitor {
                NSEvent.removeMonitor(monitor)
                self.monitor = nil
            }
        }

    }
}

#endif
