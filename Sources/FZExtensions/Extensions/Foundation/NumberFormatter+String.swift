//
//  File.swift
//
//
//  Created by Florian Zand on 22.08.22.
//

import Foundation

extension NumberFormatter {
    func intValue(from string: String) -> Int? {
        let str = strippingNonNumericCharacters(from: string)
        let formatter = NumberFormatter.forInteger()
        return formatter.number(from:str)?.intValue ?? Int(str)
    }
    
    func floatValue(from string: String) -> Float? {
        let str = strippingNonNumericCharacters(from: string)
        return self.floatingValue(Float.self, from: str) ?? Float(str)
    }
    
    func doubleValue(from string: String) -> Double? {
        let str = strippingNonNumericCharacters(from: string)
        return self.floatingValue(Double.self, from: str) ?? Double(str)
    }
    
    func boolValue(from string: String) -> Bool? {
        switch string.lowercased() {
        case "no", "0", "false", "n":
            return false
        case "yes", "1", "true", "y":
            return true
        default:
            return nil
        }
    }
    
    func timeInterval(from string: String) -> TimeInterval? {
        let allUnitStrings = Calendar.Component.allCases.flatMap({$0.stringRepresentations ?? []})
        let components = string.components(separatedBy: " ")
        var timeInterval: TimeInterval?
        
        for (index, component) in components.enumerated() {
            var found = false
            for unitString in allUnitStrings {
                if (component.lowercased().contains(unitString)) {
                    let component = component.lowercased().replacingOccurrences(of: unitString, with: "")
                    if let value = Double(component), let unitTimeInterval = Calendar.Component.allCases.first(where: {$0.stringRepresentations?.contains(unitString) ?? false})?.timeInterval {
                        timeInterval = (timeInterval ?? 0) + (unitTimeInterval*value)
                        found = true
                    }
                }
            }
            
            guard found == false else {
                break
            }
            
            let unitKind = Calendar.Component.allCases.first(where: {$0.stringRepresentations?.contains(component) ?? false})
            if(unitKind == nil || index == 0){
                continue
            }
            
            let value = Double(components[index-1])
            if(value == nil) {
                continue
            }
            
            if let unitTimeInterval = unitKind?.timeInterval, let value = value {
                if let interval = timeInterval {
                    timeInterval = (timeInterval ?? 0) + (unitTimeInterval*value)
                }
            }
        }
        return timeInterval
    }
    
    internal func strippingNonNumericCharacters(from string: String) -> String {
        let numericCharacters = Set("0123456789.,+-")
        return string.filter { numericCharacters.contains($0) }
    }
    
    internal func floatingValue<F: FloatingPoint>(_ type: F.Type, from string: String) -> F? {
        switch string {
        case ".inf", ".Inf", ".INF", "+.inf", "+.Inf", "+.INF":
            return .infinity
        case "-.inf", "-.Inf", "-.INF":
            return -.infinity
        case ".nan", ".NaN", ".NAN":
            return .nan
        default:
            return nil
        }
    }
}
