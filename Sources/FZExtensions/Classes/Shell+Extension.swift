//
//  Shell+Extension.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//

#if os(macOS)

import Foundation

extension Shell {
    static func totalSize(for path: String) -> DataSize? {
       let result = Shell.execute("du", "-s", "-k", at: path)
        if let string = try? result.get(), let first = string.split(separator: "\t").first, let kBytes = Int(first) {
            let bytes = kBytes * 1024
            return DataSize(bytes)
        }
        return nil
    }
}

#endif
