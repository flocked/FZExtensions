//
//  InfoPlist.swift
//  ATest
//
//  Created by Florian Zand on 15.01.22.
//

#if os(macOS)

import Foundation
import AppKit
import UniformTypeIdentifiers
import SwiftUI

public struct ApplicationInfo: Codable {
  
    var identifier: String
    var executable: String

    var name: String?
    var displayName: String?
    var iconFile: String?
    var iconName: String?
    var version: String?
    var shortVersion: String?
    
    init?(url: URL) {
        do {
            let data = try Data.init(contentsOf: url)
            let info = try PropertyListDecoder().decode(ApplicationInfo.self, from: data)
            self.init(info: info)
        } catch {
            return nil
        }
    }
    
    init?(path: String) {
        self.init(url: URL(fileURLWithPath: path))
    }
    
    init?(dic: [String: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: .init())
            let info = try JSONDecoder.init().decode(ApplicationInfo.self, from: data)
            self.init(info: info)
        } catch {
            return nil
        }
    }
    
    fileprivate init(info: ApplicationInfo) {
        self = info
    }
    
    private enum CodingKeys : String, CodingKey {
        case name = "CFBundleName"
        case displayName = "CFBundleDisplayName"
        case identifier = "CFBundleIdentifier"
        case iconFile = "CFBundleIconFile"
        case iconName = "CFBundleIconName"
        case executable = "CFBundleExecutable"
        case shortVersion = "CFBundleShortVersionString"
        case version = "CFBundleVersionString"
    }
}

#endif
