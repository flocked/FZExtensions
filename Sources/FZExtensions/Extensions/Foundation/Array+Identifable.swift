//
//  Array+Identifable.swift
//  FZCollection
//
//  Created by Florian Zand on 03.05.22.
//

import Foundation

public extension Sequence where Element: Identifiable {
    func contains(_ element: Element) -> Bool {
       return self.contains(where: {$0.id == element.id})
    }
    
    func contains<S: Sequence>(any elements: S) -> Bool  where S.Element == Element {
        for element in elements {
            if (self.contains(element)) {
                return true
            }
        }
        return false
    }
    
    func contains<S: Sequence>(all elements: S) -> Bool where S.Element == Element {
        for checkElement in elements {
            if (self.contains(checkElement) == false) {
                return false
            }
        }
        return true
    }
        
    var ids: [Element.ID] {
        return self.compactMap({$0.id})
    }
    
    
    subscript(id id: Element.ID) -> Element? {
       first { $0.id == id }
    }
    
    subscript<S: Sequence>(ids ids: S) -> [Element] where S.Element == Element.ID {
        self.filter({ids.contains($0.id)})
    }
    
}

public extension Collection where Element: Identifiable {
    func index(of element: Element) -> Self.Index? {
        return self.firstIndex(where: {$0.id == element.id})
    }
    func indexes<S: Sequence>(of elements: S) -> [Self.Index]  where S.Element == Element {
        return elements.compactMap({self.index(of: $0)})
    }
}

public extension RangeReplaceableCollection where Element: Identifiable {
    mutating func remove(_ element: Element)  {
        if let index = self.index(of: element) {
            self.remove(at: index)
        }
    }
    
    mutating func remove<S: Sequence>(_ elements: S)  where S.Element == Element {
        for element in elements {
            self.remove(element)
        }
    }
}

public extension Array where Element: Identifiable {
    mutating func move<S: Sequence>(_ elements: S, before: Element) where S.Element == Element  {
        if let toIndex = self.index(of: before) {
            let indexSet = IndexSet(self.indexes(of: elements))
            self.moveItems(from: indexSet, to: toIndex)
        }
    }
    
    mutating func move<S: Sequence>(_ elements: S, after: Element)  where S.Element == Element   {
        if let toIndex = self.index(of: after) {
            let indexSet = IndexSet(self.indexes(of: elements))
            self.moveItems(from: indexSet, to: toIndex)
        }
    }
}
