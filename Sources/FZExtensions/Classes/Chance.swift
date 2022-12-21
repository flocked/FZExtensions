//
//  File.swift
//  
//
//  Created by Florian Zand on 22.12.22.
//

import Foundation

public struct Chance {
    public static func by(_ amount: CGFloat) -> Bool {
        let amount = amount.clamped(1.0)
        let random = CGFloat.random(in:  0...1.0)
        return (amount >= random)
    }
    
    public static func callAsFunction(_ amount: CGFloat) -> Bool {
        return self.by(amount)
    }
}
