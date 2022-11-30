//
//  Array+Extension.swift
//  ATest
//
//  Created by Florian Zand on 15.01.22.
//

import Foundation

public extension Array {
  subscript(safe safeIndex: Int) -> Element? {
        if self.isEmpty == false, safeIndex < self.count-1 {
            return self[safeIndex]
        }
        return nil
    }
    
    subscript(indexes: IndexSet) -> [Element] {
       return indexes.compactMap({self[safe: $0]})
    }
}

public extension Sequence {
    func indexes(where predicate: (Element) throws -> Bool) rethrows -> IndexSet {
        var indexes = IndexSet()
        for (index, element) in self.enumerated() {
            if (try predicate(element) == true) {
                indexes.insert(index)
            }
        }
        return indexes
    }
}

public extension Sequence where Element: Equatable {
    func unique() -> [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}


public extension Array where Element: Equatable {
    mutating func uniqued() {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        self = uniqueValues
    }
}

public extension Sequence {
    func sorted<T: Comparable>(
        by keyPath: KeyPath<Element, T>,
        using comparator: (T, T) -> Bool = (<)
    ) -> [Element] {
        sorted { a, b in
            comparator(a[keyPath: keyPath], b[keyPath: keyPath])
        }
    }
    
    func sorted<T: Comparable>(
        by keyPath: KeyPath<Element, T?>,
        using comparator: (T, T) -> Bool = (<)
    ) -> [Element] {
        sorted { a, b in
            guard let b = b[keyPath: keyPath] else { return true }
            guard let a = a[keyPath: keyPath] else { return false }
            return comparator(a, b)
        }
    }
}


public extension Array {
    mutating func sort<T: Comparable>(by compare: (Element) -> T, asc ascendant: Bool = true) {
        if ascendant {
            self = self.sorted {compare($0) < compare($1)}
        } else {
            self = self.sorted {compare($0) > compare($1)}
        }
    }
    
    func sorted<T: Comparable>(by compare: (Element) -> T, asc ascendant: Bool = true) -> Array {
        if ascendant {
            return self.sorted {compare($0) < compare($1)}
        } else {
            return self.sorted {compare($0) > compare($1)}
        }
    }
}

public extension Sequence where Element: RawRepresentable, Element.RawValue: Equatable  {
    func first(rawValue: Element.RawValue) -> Element? {
        return self.first(where: {$0.rawValue == rawValue})
    }
}

/*
public extension Sequence where Iterator.Element: AnyObject {
    func unique() ->  [Iterator.Element] {
        var elements = [Iterator.Element]()
        for element in self {
            if (elements.contains(where: {$0 === element}) == false) {
                elements.append(element)
            }
        }
        return elements
    }
}
*/

public extension Sequence where Element: Equatable  {
    func contains<S: Sequence>(any elements: S) -> Bool where S.Element == Element {
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
}

public extension RangeReplaceableCollection where Self.Indices.Element == Int {
    @discardableResult
    mutating func removeItems(in indexSet: IndexSet) -> [Self.Element] {
        var returnItems = [Self.Element]()

        for (index, _) in self.enumerated().reversed() {
            if indexSet.contains(index) {
                returnItems.insert(self.remove(at: index), at: startIndex)
            }
        }
        return returnItems
    }

    @discardableResult
    mutating func moveItems(from indexSet: IndexSet, to destinationIndex: Index) -> Bool {

        guard indexSet.isSubset(of: IndexSet(indices)) else {
            debugPrint("Source indices out of range.")
            return false
            }
        guard (0..<self.count + indexSet.count).contains(destinationIndex) else {
            debugPrint("Destination index out of range.")
            return false
        }

        let itemsToMove = self.removeItems(in: indexSet)

        let modifiedDestinationIndex:Int = {
            return destinationIndex - indexSet.filter { destinationIndex > $0 }.count
        }()

        self.insert(contentsOf: itemsToMove, at: modifiedDestinationIndex)

        return true
    }
}

public extension Sequence where Self: IteratorProtocol  {
    func all() -> [Element] {
        var elements = [Element]()
        self.forEach({elements.append($0)})
        return elements
    }
    
    func all(completion: @escaping ([Element]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var elements = [Element]()
            self.forEach({elements.append($0)})
            DispatchQueue.main.async {
                completion(elements)
            }
        }
    }
}
