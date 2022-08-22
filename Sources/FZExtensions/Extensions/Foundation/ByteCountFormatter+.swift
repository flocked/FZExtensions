//
//  ByteCountFormatter+.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//

import Foundation

extension ByteCountFormatter {
    convenience init(unit: Units, countStyle: CountStyle = .file) {
        self.init()
        self.allowedUnits = unit
        self.countStyle = countStyle
    }
}
