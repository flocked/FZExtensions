//
//  AsyncSequence+.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//

import Foundation

public extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { $0.append($1) }
    }
}
