//
//  DateTextField.swift
//
//  Created by Tyler Hall on 3/12/20.
//  Copyright © 2020 Click On Tyler. All rights reserved.
//

#if os(macOS)
import AppKit

public class DateTextField: NSTextField {
    internal let dateFormatter: DateFormatter = { let formatter = DateFormatter(); formatter.dateStyle = .medium; formatter.timeStyle = .medium; return formatter }()
    internal static let relativeDateFormatter = RelativeDateTimeFormatter()

    internal static let slowRefreshInterval: TimeInterval = 30 // How quickly the timer should repeat after it's been a while.
    internal static let buffer: TimeInterval = 2
    
    public var date: Date? {
        didSet { configurateDateString() } }

    public var updateDateLive = true {
        didSet {  updateDateString() } }
    
    public var liveUpdateTimer: Timer? {
        didSet {  configurateDateString() } }
    
    public var refreshInterval: TimeInterval = 5 {
        didSet {
            self.liveUpdateTimer?.invalidate()
            self.configurateDateString()
        }
    }
    
    public var useRelativeDate = true {
        didSet {  updateDateString() } }
    
    public var dateStyle: DateFormatter.Style = .medium {
        didSet {
            dateFormatter.dateStyle = self.dateStyle
            updateDateString()
        } }
    
    public var timeStyle: DateFormatter.Style = .medium {
        didSet {
            dateFormatter.timeStyle = self.timeStyle
            updateDateString()
        } }
    
    internal func configurateDateString() {
        if (updateDateLive == false) {
            liveUpdateTimer?.invalidate()
        }
        
        if let date = self.date {
                self.updateDateString()

            let delta = Date().timeIntervalSince(date)
                let liveUpdateInterval: TimeInterval = (delta < DateTextField.slowRefreshInterval) ? self.refreshInterval : (DateTextField.slowRefreshInterval - DateTextField.buffer)
                
                liveUpdateTimer?.invalidate()
                liveUpdateTimer = Timer.scheduledTimer(withTimeInterval: liveUpdateInterval, repeats: true, block: { (timer) in
                    let delta = Date().timeIntervalSince(date)
                    if delta > (DateTextField.slowRefreshInterval + DateTextField.buffer) {
                        self.date = date
                    }
                    self.updateDateString()
                })
        } else {
            liveUpdateTimer?.invalidate()
            dateString = nil
            self.toolTip = nil
        }
    }
    
    public override var stringValue: String {
        didSet {
            if (stringValue != dateString) {
                self.date = nil
            }
        }
    }
    
    public override var attributedStringValue: NSAttributedString {
        didSet {
            self.date = nil
        }
    }
    
    internal var dateString: String? = nil
    internal func updateDateString() {
        if let date = date {
            if (useRelativeDate) {
                dateString = DateTextField.relativeDateFormatter.localizedString(for: date, relativeTo: Date())
                stringValue = DateTextField.relativeDateFormatter.localizedString(for: date, relativeTo: Date())
                toolTip = dateFormatter.string(from: date)
            } else {
                dateString = dateFormatter.string(from: date)
                stringValue = dateFormatter.string(from: date)
                toolTip = DateTextField.relativeDateFormatter.localizedString(for: date, relativeTo: Date())
            }
        } else {
            liveUpdateTimer?.invalidate()
            dateString = nil
            self.toolTip = nil
        }
    }
}
#elseif canImport(UIKit)
import UIKit
public class DateTextField: UILabel {
    internal let dateFormatter: DateFormatter = { let formatter = DateFormatter(); formatter.dateStyle = .medium; formatter.timeStyle = .medium; return formatter }()
    internal static let relativeDateFormatter = RelativeDateTimeFormatter()

    internal static let slowRefreshInterval: TimeInterval = 30 // How quickly the timer should repeat after it's been a while.
    internal static let buffer: TimeInterval = 2
    
    public var date: Date? {
        didSet { configurateDateString() } }

    public var updateDateLive = true {
        didSet {  updateDateString() } }
    
    public var liveUpdateTimer: Timer? {
        didSet {  configurateDateString() } }
    
    public var refreshInterval: TimeInterval = 5 {
        didSet {
            self.liveUpdateTimer?.invalidate()
            self.configurateDateString()
        }
    }
    
    public var useRelativeDate = true {
        didSet {  updateDateString() } }
    
    public var dateStyle: DateFormatter.Style = .medium {
        didSet {
            dateFormatter.dateStyle = self.dateStyle
            updateDateString()
        } }
    
    public var timeStyle: DateFormatter.Style = .medium {
        didSet {
            dateFormatter.timeStyle = self.timeStyle
            updateDateString()
        } }
    
    internal func configurateDateString() {
        if (updateDateLive == false) {
            liveUpdateTimer?.invalidate()
        }
        
        if let date = self.date {
                self.updateDateString()

            let delta = Date().timeIntervalSince(date)
                let liveUpdateInterval: TimeInterval = (delta < DateTextField.slowRefreshInterval) ? self.refreshInterval : (DateTextField.slowRefreshInterval - DateTextField.buffer)
                
                liveUpdateTimer?.invalidate()
                liveUpdateTimer = Timer.scheduledTimer(withTimeInterval: liveUpdateInterval, repeats: true, block: { (timer) in
                    let delta = Date().timeIntervalSince(date)
                    if delta > (DateTextField.slowRefreshInterval + DateTextField.buffer) {
                        self.date = date
                    }
                    self.updateDateString()
                })
        } else {
            liveUpdateTimer?.invalidate()
            dateString = nil
        }
    }
    
    public override var text: String? {
        didSet {
            if (text != dateString) {
                self.date = nil
            }
        }
    }
    
    public override var attributedText: NSAttributedString? {
        didSet {
            self.date = nil
        }
    }
    
    internal var dateString: String? = nil
    internal func updateDateString() {
        if let date = date {
            if (useRelativeDate) {
                dateString = DateTextField.relativeDateFormatter.localizedString(for: date, relativeTo: Date())
                text = DateTextField.relativeDateFormatter.localizedString(for: date, relativeTo: Date())
            } else {
                dateString = dateFormatter.string(from: date)
                text = dateFormatter.string(from: date)
            }
        } else {
            liveUpdateTimer?.invalidate()
            dateString = nil
        }
    }
}

#endif
