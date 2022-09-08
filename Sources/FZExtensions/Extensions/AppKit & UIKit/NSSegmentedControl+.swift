//
//  NSSegmentedControl+.swift
//  FZExtensions
//
//  Created by Florian Zand on 18.08.22.
//

#if os(macOS)

import Foundation
import AppKit

public extension NSSegmentedControl {
  func selectSegment(named name: String) {
    self.selectedSegment = -1
    for i in 0..<segmentCount {
      if self.label(forSegment: i) == name {
        self.selectedSegment = i
      }
    }
  }
}

#endif
