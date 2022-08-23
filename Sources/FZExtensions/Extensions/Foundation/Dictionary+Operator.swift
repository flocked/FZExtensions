//
//  File.swift
//  
//
//  Created by Florian Zand on 23.08.22.
//

import Foundation

public extension Dictionary where Value : Any {
     static func +=(lhs: inout [Key:Value], rhs:[Key:Value]) {
        rhs.forEach {
            lhs[$0] = $1
        }
    }
}
