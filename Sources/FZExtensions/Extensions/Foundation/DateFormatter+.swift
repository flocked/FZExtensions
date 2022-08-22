//
//  DateFormatter+.swift
//  FZCollection
//
//  Created by Florian Zand on 02.06.22.
//

import Foundation

public extension DateFormatter {
    convenience init(_ format: String) {
        self.init()
        self.dateFormat = format
    }
}
