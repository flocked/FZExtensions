//
//  Array+Extension.swift
//  ATest
//
//  Created by Florian Zand on 15.01.22.
//

import Foundation

extension Sequence where Element: Equatable {
    func unique() -> [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}

extension Array where Element: Equatable {
    mutating func uniqued() {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        self = uniqueValues
    }
}

extension Sequence {
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


extension Array {
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

extension Sequence where Iterator.Element: Hashable {
    func unique() ->  [Iterator.Element] {
        return Array(Set(self))
    }
}

extension Sequence where Element: RawRepresentable, Element.RawValue: Equatable  {
    func first(rawValue: Element.RawValue) -> Element? {
        return self.first(where: {$0.rawValue == rawValue})
    }
}

extension Sequence where Iterator.Element: AnyObject {
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

extension Sequence where Element: Equatable  {
    func contains(any elements: Self) -> Bool {
        for element in elements {
            if (self.contains(element)) {
                return true
            }
        }
        return false
    }
    
    func contains(all elements: Self) -> Bool {
        for checkElement in elements {
            if (self.contains(checkElement) == false) {
                return false
            }
        }
        return true
    }
}

extension Array {
    var middle: Element? {
        guard count != 0 else { return nil }
        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
}

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}

extension RangeReplaceableCollection where Self.Indices.Element == Int {

    /**
        Removes the items contained in an `IndexSet` from the collection.
        Items outside of the collection range will be ignored.

        - Parameter indexSet: The set of indices to be removed.
        - Returns: Returns the removed items as an `Array<Self.Element>`.
    */
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


    /**
        Moves a set of items with indices contained in an `IndexSet` to a
        destination index within the collection.

        - Parameters:
            - indexSet: The `IndexSet` of items to move.
            - destinationIndex: The destination index to which to move the items.
        - Returns: `true` if the operation completes successfully else `false`.

        If any items fall outside of the range of the collection this function
        will fail with a fatal error.
    */
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
