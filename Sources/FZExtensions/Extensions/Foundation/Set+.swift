//
//  Set+Remove.swift
//  NewImageViewer
//
//  Created by Florian Zand on 15.09.22.
//

import Foundation

extension Set {
    mutating func remove(_ elements: [Self.Element]) {
        for element in elements {
            self.remove(element)
        }
    }
    mutating func insert(_ elements: [Self.Element]) {
        for element in elements {
            self.insert(element)
        }
    }
    
     func filtered(where filter: ((Self.Element)->Bool)) -> Set<Self.Element> {
        return self.filter(filter)
    }
    
    mutating func filter(where filter: ((Self.Element)->Bool))  {
        var filteredElements = Set<Self.Element>()
        for element in self {
            if (filter(element) == true) {
                filteredElements.insert(element)
            }
        }
        self = filteredElements
    }
    
    mutating func removeAll(where remove: ((Self.Element)->Bool)) {
        self.remove(Array(self.filter(remove)))
    }
}
