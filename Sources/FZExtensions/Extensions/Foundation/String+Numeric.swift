//
//  File.swift
//  
//
//  Created by Florian Zand on 22.08.22.
//

import Foundation

public extension String {

    func strippingNonNumericCharacters() -> String {
        let numericCharacters = Set("0123456789.,+-")
        return self.filter { numericCharacters.contains($0) }
    }
    
    var intValue : Int?  {
        let str = self.strippingNonNumericCharacters()
        let formatter = NumberFormatter.forInteger()
        return formatter.number(from:str)?.intValue ?? Int(str)
    }
    
    var floatValue : Float? {
        let str = self.strippingNonNumericCharacters()
        let formatter = NumberFormatter.forFloatingPoint(numberOfDigits:6)
        return formatter.number(from:str)?.floatValue ?? Float(str)
    }

    var doubleValue : Double? {
        let str = self.strippingNonNumericCharacters()
        let formatter = NumberFormatter.forFloatingPoint(numberOfDigits:6)
        return formatter.number(from:str)?.doubleValue ?? Double(str)
    }
    
    var boolValue : Bool? {
        switch self.lowercased() {
        case "no", "0", "false":
            return false
        case "yes", "1", "true":
            return true
        default:
            return nil
        }
    }
    
}
