//
//  DisplayLinkTimer.swift
//  FZCollection
//
//  Created by Florian Zand on 02.06.22.
//
import Foundation
import Combine
import CoreGraphics
import QuartzCore

public class DisplayLinkTimer {
    public typealias Action = (DisplayLinkTimer) -> Void
    
    public var timeInterval: TimeInterval = 0.0
    public var repeating = true
    public let action: Action
    
    internal var displayLink: AnyCancellable? = nil
    internal var timeIntervalSinceLastFire: TimeInterval = 0.0
    internal var previousTimestamp: TimeInterval = 0.0
    internal var lastFireDate: Date? = nil
    
    convenience init(repeating: TimeInterval, shouldFire: Bool = true, action: @escaping Action) {
        self.init(timeInterval: repeating, repeating: true, shouldFire: shouldFire, action: action)
    }
    
    convenience init(repeating: TimeInterval, shouldFire: Bool = true, target: AnyObject, selector: Selector) {
        let action: Action =  { timer in _ = target.perform(selector)}
        self.init(timeInterval: repeating, repeating: true, shouldFire: shouldFire, action: action)
    }
    
    convenience init(timeInterval: TimeInterval, repeating: Bool, shouldFire: Bool = true, target: AnyObject, selector: Selector) {
        let action: Action =  { timer in _ = target.perform(selector)}
        self.init(timeInterval: timeInterval, repeating: true, shouldFire: shouldFire, action: action)
    }
    
    init(timeInterval: TimeInterval, repeating: Bool, shouldFire: Bool = true, action: @escaping Action) {
        self.timeInterval = timeInterval
        self.repeating = repeating
        self.action = action
        if (shouldFire) {
            fire()
        }
    }
    
    public var nextFireDate: Date? {
      //  (self.isRunning) ? Date().addingTimeInterval(-self.timeIntervalSinceLastFire+self.timeInterval) : nil
        self.lastFireDate?.addingTimeInterval(self.timeInterval)
    }
    
    public var isRunning: Bool {
        return (displayLink != nil)
    }
    
    public func fire() {
        if isRunning == false {
            self.previousTimestamp = 0.0
            self.timeIntervalSinceLastFire = 0.0
            self.lastFireDate = Date()
            self.displayLink = DisplayLink.shared.sink{ [weak self] frame in
                if let self = self {
                    let timeIntervalCount = frame.timestamp - self.previousTimestamp
                    self.timeIntervalSinceLastFire = self.timeIntervalSinceLastFire + timeIntervalCount
                    self.previousTimestamp = frame.timestamp
                    if (self.timeIntervalSinceLastFire > self.timeInterval) {
                        self.timeIntervalSinceLastFire = 0.0
                        self.lastFireDate = Date()
                        self.action(self)
                        if (self.repeating == false) {
                            self.stop()
                        }
                    }
                }
            }
        }
    }
    
    public func stop() {
        displayLink?.cancel()
        self.lastFireDate = nil
        self.timeIntervalSinceLastFire = 0.0
        self.previousTimestamp = 0.0
    }
    
    deinit {
        displayLink?.cancel()
        displayLink = nil
    }
}

extension DisplayLinkTimer {
    var bpm: CGFloat {
        get {
            return timeInterval * 6
        }
        set {
            timeInterval = 6 / newValue
        }
    }
}
