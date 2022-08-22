//
//  Number+Clamp.swift
//  FZExtensions
//
//  Created by Florian Zand on 06.06.22.
//

import Foundation

public extension BinaryInteger {
    func clamped(_ maxValue: Self) -> Self {
        clamped(lowerBound: 0, upperBound: maxValue)
    }
    
   mutating func clamp(_ maxValue: Self) {
        clamp(lowerBound: 0, upperBound: maxValue)
    }
    
    mutating func clamp(_ range: ClosedRange<Self>) {
        clamp(lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
    
    func clamped(_ range: ClosedRange<Self>) -> Self {
        clamped(lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
    
    mutating func clamp(lowerBound: Self, upperBound: Self) {
        self = self.clamped(lowerBound: lowerBound, upperBound: upperBound)
   }
    
    func clamped(lowerBound: Self, upperBound: Self) -> Self {
       min(upperBound, max(lowerBound, self))
    }
}

public extension BinaryFloatingPoint {
    func clamped(_ maxValue: Self) -> Self {
        clamped(lowerBound: 0, upperBound: maxValue)
    }
    
   mutating func clamp(_ maxValue: Self) {
        clamp(lowerBound: 0, upperBound: maxValue)
    }
    
    mutating func clamp(_ range: ClosedRange<Self>) {
        clamp(lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
    
    func clamped(_ range: ClosedRange<Self>) -> Self {
        clamped(lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
    
    mutating func clamp(lowerBound: Self, upperBound: Self) {
        self = self.clamped(lowerBound: lowerBound, upperBound: upperBound)
   }
    
    func clamped(lowerBound: Self, upperBound: Self) -> Self {
       min(upperBound, max(lowerBound, self))
    }
}
