//
//  URL+Extension.swift
//  FZCollection
//
//  Created by Florian Zand on 07.05.22.
//

import Foundation

public extension URL {
    
   internal func resourceValues(for key: URLResourceKey) throws -> URLResourceValues {
        return try self.resourceValues(forKeys: [key])
    }
    
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
    
     var queryComponents: [String:String] {
        var result : [String:String] = [:]
        guard let query = self.query else { return result }
        let components = query.components(separatedBy: "&")
        for component in components {
            let parts = component.components(separatedBy: "=")
            if parts.count == 2
            {
                guard let key = (parts[0] as NSString).removingPercentEncoding else { continue }
                guard let value = (parts[1] as NSString).removingPercentEncoding else { continue }
                result[key] = value
            }
        }
        return result
    }
}
