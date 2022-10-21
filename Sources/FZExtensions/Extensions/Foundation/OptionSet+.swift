//
//  File.swift
//  
//
//  Created by Florian Zand on 21.10.22.
//

import Foundation

public extension OptionSet {
    func contains(all members: Self.Element...) -> Bool {
        return self.contains(all: members)
    }
    
    func contains(all members: [Self.Element]) -> Bool {
        for member in members {
            if (self.contains(member) == false) {
                return false
            }
        }
        return true
    }
    
    func contains(any members: Self.Element...) -> Bool {
        return contains(any: members)
    }
    
    func contains(any members: [Self.Element]) -> Bool {
        for member in members {
            if self.contains(member) {
                return true
            }
        }
        return false
    }
}
