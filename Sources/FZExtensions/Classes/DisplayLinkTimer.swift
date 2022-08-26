//
//  DisplayLinkTimer.swift
//  FZCollection
//
//  Created by Florian Zand on 02.06.22.
//

import Foundation
import AppKit
import Combine

class DisplayLinkTimer {
    typealias Action = () -> Void
    var timeInterval: TimeInterval = 0.0
    var repeating = true
    private let action: Action
    private var displayLink: AnyCancellable? = nil
    private var count: TimeInterval = 0.0
    
    convenience init(repeating: TimeInterval, shouldFire: Bool = true, action: @escaping Action) {
        self.init(timeInterval: repeating, repeating: true, shouldFire: shouldFire, action: action)
    }
    
    convenience init(repeating: TimeInterval, shouldFire: Bool = true, target: AnyObject, selector: Selector) {
        let action =  { _ = target.perform(selector)}
        self.init(timeInterval: repeating, repeating: true, shouldFire: shouldFire, action: action)
    }
    
    convenience init(timeInterval: TimeInterval, repeating: Bool, shouldFire: Bool = true, target: AnyObject, selector: Selector) {
        let action =  { _ = target.perform(selector)}
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
    
    private var previousTimestamp: TimeInterval = 0.0
    func fire() {
        if displayLink == nil {
            self.previousTimestamp = 0.0
            self.count = 0.0
            self.displayLink = DisplayLink.shared.sink{ [weak self] frame in
            if let self = self {
                let timeIntervalCount = frame.timestamp - self.previousTimestamp
                self.count = self.count + timeIntervalCount
                self.previousTimestamp = frame.timestamp
                if (self.count > self.timeInterval) {
                    self.count = 0.0
                    self.action()
                    if (self.repeating == false) {
                        self.stop()
                    }
                }
            }
        }
    }
    }
    
    func stop() {
        displayLink?.cancel()
        self.count = 0.0
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
