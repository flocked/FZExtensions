//
//  NumberFormatter+.swift
//  FZCollection
//
//  Created by Florian Zand on 06.06.22.
//

import Foundation

extension NumberFormatter {
    static func decimal(min: Int = 0, max: Int = 0) -> NumberFormatter {
        let formatter = NumberFormatter(minFractionDigits: min, maxFractionDigits: max)
        formatter.numberStyle = .decimal
        return formatter
    }
    
    static func percent(min: Int = 0, max: Int = 0) -> NumberFormatter {
        let formatter = NumberFormatter(minFractionDigits: min, maxFractionDigits: max)
        formatter.numberStyle = .percent
        return formatter
    }
    
    convenience init(minFractionDigits: Int) {
        self.init()
        self.minimumFractionDigits = minFractionDigits
    }
    
    convenience init(maxFractionDigits: Int) {
        self.init()
        self.maximumFractionDigits = maxFractionDigits
    }
    
    convenience init(minFractionDigits: Int, maxFractionDigits: Int) {
        self.init()
        self.minimumFractionDigits = minFractionDigits
        self.maximumFractionDigits = maxFractionDigits
    }
    
    func string(from value: Double) -> String? { self.string(from: NSNumber(value: value)) }
    func string(from value: Float) -> String? { self.string(from: NSNumber(value: value)) }
    func string(from value: CChar) -> String? { self.string(from: NSNumber(value: value)) }
    func string(from value: Bool) -> String? { self.string(from: NSNumber(value: value)) }
    func string(from value: Int) -> String? {  self.string(from: NSNumber(value: value)) }
    func string(from value: Int16) -> String? {  self.string(from: NSNumber(value: value)) }
    func string(from value: Int32) -> String? {  self.string(from: NSNumber(value: value)) }
    func string(from value: Int64) -> String? {  self.string(from: NSNumber(value: value)) }
    func string(from value: UInt) -> String? {  self.string(from: NSNumber(value: value)) }
    func string(from value: UInt16) -> String? {  self.string(from: NSNumber(value: value)) }
    func string(from value: UInt32) -> String? {  self.string(from: NSNumber(value: value)) }
    func string(from value: UInt64) -> String? {  self.string(from: NSNumber(value: value)) }
}
