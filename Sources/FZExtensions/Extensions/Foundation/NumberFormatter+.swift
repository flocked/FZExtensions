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
    

     static func forInteger(with format: String = "#,###", numberOfDigits: Int = 0, locale: Locale? = nil) -> NumberFormatter {
            let formatter = NumberFormatter()
            formatter.locale = locale ?? Locale.current
            formatter.positiveFormat = format
            formatter.negativeFormat = "-\(format)"
            formatter.minimumIntegerDigits = numberOfDigits
            formatter.usesGroupingSeparator = false
            return formatter
        }

     static func forFloatingPoint(with format: String = "#.#", numberOfDigits: Int = 1, locale: Locale? = nil) -> NumberFormatter {
            let formatter = NumberFormatter()
            formatter.locale = locale ?? Locale.current
            formatter.maximumFractionDigits = numberOfDigits
            formatter.positiveFormat = format
            formatter.negativeFormat = "-\(format)"
            return formatter
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

extension Int {
    func localized(with format: String = "#,###", numberOfDigits: Int = 0, locale: Locale? = nil) -> String {
        let formatter = NumberFormatter.forInteger(with:format, numberOfDigits:numberOfDigits, locale:locale)
        return formatter.string(from:NSNumber(value:self)) ?? "\(self)"
    }
}

extension Double {
    func localized(with format: String = "#.#", numberOfDigits: Int = 1, locale: Locale? = nil) -> String {
        let formatter = NumberFormatter.forFloatingPoint(with:format, numberOfDigits:numberOfDigits, locale:locale)
        return formatter.string(from:NSNumber(value:self)) ?? "\(self)"
    }
}

extension Float {
    func localized(with format: String = "#.#", numberOfDigits: Int = 1, locale: Locale? = nil) -> String {
        let formatter = NumberFormatter.forFloatingPoint(with:format, numberOfDigits:numberOfDigits, locale:locale)
        return formatter.string(from:NSNumber(value:self)) ?? "\(self)"
    }
}

extension CGFloat {
    func localized(with format: String = "#.#", numberOfDigits: Int = 1, locale: Locale? = nil) -> String {
        return Double(self).localized(with:format, numberOfDigits:numberOfDigits, locale:locale)
    }
}
