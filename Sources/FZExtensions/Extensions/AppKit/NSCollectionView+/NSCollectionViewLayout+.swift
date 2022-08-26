//
//  File.swift
//  
//
//  Created by Florian Zand on 23.08.22.
//

import Foundation
#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension NSCollectionViewLayout {
func invalidateLayout(animated duration: TimeInterval = 0.15) {
    guard duration != 0.0 else { self.invalidateLayout()
        return }
    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = duration
    NSAnimationContext.current.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
    collectionView?.animator().performBatchUpdates(nil, completionHandler: nil)
    NSAnimationContext.endGrouping()
}
}
