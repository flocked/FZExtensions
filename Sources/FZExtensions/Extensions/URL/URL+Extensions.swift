//
//  URL+Extension.swift
//  FZCollection
//
//  Created by Florian Zand on 07.05.22.
//

import Foundation

extension URL {
    var parent: URL? {
        let parent = self.deletingLastPathComponent()
        if (parent.path != self.path) {
            return parent
        }
        return nil
    }
    
    var fileExists: Bool {
        FileManager.default.fileExists(atPath: self.path)
    }
}
