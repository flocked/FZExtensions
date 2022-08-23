//
//  Bundle+Extension.swift
//  ATest
//
//  Created by Florian Zand on 21.01.22.
//

import Foundation

public extension Bundle {
    enum BundlePlatform {
        case macOS
        case maciOS
    }
    
    var isApplicationBundle: Bool {
        return self.bundlePath.lowercased().contains(".app")
    }
    
    var bundleName: String {
        return self.bundleURL.lastPathComponent
    }
    
    var executableDirectoryURL: URL? {
        return self.executableURL?.deletingLastPathComponent()
    }
    
    var bundleNameExcludingExtension: String {
        return self.bundleURL.deletingPathExtension().lastPathComponent
    }
    
    var platform: BundlePlatform {
        if let executableURL = self.executableURL {
            if (executableURL.path.contains("Wrapper")) {
                return .maciOS
            }
        }
        return .macOS
    }
    
    var contentsURL: URL? {
        if (platform == .macOS) {
            return self.bundleURL.appendingPathComponent("Contents")
        } else {
            return self.executableURL?.deletingLastPathComponent().deletingLastPathComponent()
        }
    }
    
    var contentsPath: String? {
        return self.contentsURL?.path
    }
    
    var infoURL: URL? {
        return contentsURL?.appendingPathComponent("Info.plist")
    }
    
    var infoPath: String? {
        return infoURL?.path
    }
}
