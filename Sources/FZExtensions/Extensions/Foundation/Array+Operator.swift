//
//  File.swift
//  
//
//  Created by Florian Zand on 23.08.22.
//

import Foundation

public extension Array where Element: Any {
     static func +=(lhs: inout [Element], rhs: Element?) {
        if let rhs = rhs
        {
            lhs.append(rhs)
        }
    }
    
    #if !compiler(>=5)
     static func +=(lhs: inout [Element], rhs: [Element]) {
        lhs.append(contentsOf:rhs)
    }
        
     static func +=(lhs: inout [Element], rhs: [Element]?) {
        guard let rhs = rhs else { return }
        lhs.append(contentsOf:rhs)
    }
    #endif

     static func +(lhs: [Element], rhs: Element?) -> [Element] {
        var copy = lhs
        if let rhs = rhs {
            copy.append(rhs)
        }
        return copy
    }

     static func +(lhs: Element?, rhs: [Element]) -> [Element] {
        var copy = rhs
        if let lhs = lhs
        {
            copy.insert(lhs, at: 0)
        }
        return copy
    }
}
