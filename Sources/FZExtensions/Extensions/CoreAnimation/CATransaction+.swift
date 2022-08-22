//
//  CATransaction+.swift
//  FZExtensions
//
//  Created by Florian Zand on 06.06.22.
//

import Foundation
import QuartzCore

extension CATransaction {
    public static func perform(animated: Bool = true, duration: CGFloat = 0.4, animations:() ->Void, completinonHandler:(() ->Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completinonHandler)
        CATransaction.setAnimationDuration(animated ? duration: 0.0)
        CATransaction.setDisableActions(!animated)
        animations()
        CATransaction.commit()
    }
}
