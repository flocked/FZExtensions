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
    
    enum TwitterType: String {
        case likes = "likes"
        case media = "media"
        case all
    }
    
    static func twitter(_ type: TwitterType = .media, user: String, at path: String = "."){
        switch type {
        case .likes:
            let twitter = "https://twitter.com/" + user + "likes"
            _ = Shell.execute("gallery-dl", twitter, at: path)
        case .media:
            let twitter = "https://twitter.com/" + user + "media"
            _ = Shell.execute("gallery-dl", twitter, at: path)
        case .all:
            var twitter = "https://twitter.com/" + user + "media"
            _ = Shell.execute("gallery-dl", twitter, at: path)
            twitter = "https://twitter.com/" + user + "likes"
            _ = Shell.execute("gallery-dl", twitter, at: path)
        }
    }
    
    static func twitter(_ type: TwitterType = .media, users: [String], at path: String = "."){
        for user in users {
            Shell.twitter(type, user: user, at: path)
        }
    }
    
}

#endif
