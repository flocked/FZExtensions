//
//  JSONEncoder+.swift
//  FZCollection
//
//  Created by Florian Zand on 02.06.22.
//

import Foundation

public extension JSONEncoder.DateEncodingStrategy {
    static func formatted(_ format: String) -> JSONEncoder.DateEncodingStrategy {
        return .formatted(DateFormatter(format))
    }
}

public extension JSONEncoder {
    static let iso8601 = JSONEncoder(dateEncodingStrategy: .iso8601)
    static let iso8601PrittyPrinted = JSONEncoder(dateEncodingStrategy: .iso8601, outputFormatting: .prettyPrinted)
}

public extension JSONEncoder {
    convenience init(dateEncodingStrategy: DateEncodingStrategy,
                         outputFormatting: OutputFormatting = [],
                      keyEncodingStrategy: KeyEncodingStrategy = .useDefaultKeys) {
        self.init()
        self.dateEncodingStrategy = dateEncodingStrategy
        self.outputFormatting = outputFormatting
        self.keyEncodingStrategy = keyEncodingStrategy
    }
}

public extension JSONDecoder.DateDecodingStrategy {
    static func formatted(_ format: String) -> JSONDecoder.DateDecodingStrategy {
        return .formatted(DateFormatter(format))
    }
}

public extension JSONDecoder {
     static let iso8601 = JSONDecoder(dateDecodingStrategy: .iso8601)
}

public extension JSONDecoder {
     convenience init(dateDecodingStrategy: DateDecodingStrategy,
                     keyDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys) {
        self.init()
        self.dateDecodingStrategy = dateDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
    }
}
