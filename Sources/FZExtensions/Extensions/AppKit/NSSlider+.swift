//
//  NSSlider+.swift
//  FZExtensions
//
//  Created by Florian Zand on 18.08.22.
//

#if os(macOS)

import Foundation
import AppKit

public extension NSSlider {
  /** Returns the position of knob center by point */
  func knobPointPosition() -> CGFloat {
    let sliderOrigin = frame.origin.x + knobThickness / 2
    let sliderWidth = frame.width - knobThickness
    assert(maxValue > minValue)
    let knobPos = sliderOrigin + sliderWidth * CGFloat((doubleValue - minValue) / (maxValue - minValue))
    return knobPos
  }
}

#endif
