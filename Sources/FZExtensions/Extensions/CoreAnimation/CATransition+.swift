//
//  CATransition+.swift
//  FZExtensions
//
//  Created by Florian Zand on 22.08.22.
//

import Foundation
import QuartzCore

public extension CATransition {
    convenience init(_ type: CATransitionType, _ duration: CGFloat) {
        self.init()
        self.type = type
        self.duration = duration
    }
}
