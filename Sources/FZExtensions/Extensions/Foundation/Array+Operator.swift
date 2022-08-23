//
//  File.swift
//  
//
//  Created by Florian Zand on 23.08.22.
//

import Foundation

extension Array where Element: Any {
    public static func +=(lhs: inout [Element], rhs: Element?) {
        if let rhs = rhs
        {
            lhs.append(rhs)
        }
    }
    
    #if !compiler(>=5)
    public static func +=(lhs: inout [Element], rhs: [Element]) {
        lhs.append(contentsOf:rhs)
    }
        
    public static func +=(lhs: inout [Element], rhs: [Element]?) {
        guard let rhs = rhs else { return }
        lhs.append(contentsOf:rhs)
    }
    #endif

    public static func +(lhs: [Element], rhs: Element?) -> [Element] {
        var copy = lhs
        if let rhs = rhs {
            copy.append(rhs)
        }
        return copy
    }

    public static func +(lhs: Element?, rhs: [Element]) -> [Element] {
        var copy = rhs
        if let lhs = lhs
        {
            copy.insert(lhs, at: 0)
        }
        return copy
    }
}
