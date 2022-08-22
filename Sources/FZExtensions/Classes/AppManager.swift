//
//  AppManager.swift
//  FZExtensions
//
//  Created by Florian Zand on 10.07.22.
//

#if os(macOS)

import Foundation
import Cocoa

extension NSApplication {
    public func relaunch() {
        let executablePath = Bundle.main.executablePath! as NSString
        let fileSystemRepresentedPath = executablePath.fileSystemRepresentation
        let fileSystemPath = FileManager.default.string(withFileSystemRepresentation: fileSystemRepresentedPath, length: Int(strlen(fileSystemRepresentedPath)))
        Process.launchedProcess(launchPath: fileSystemPath, arguments: [])
        NSApp.terminate(self)
    }
    
    public func checkAccessibilityAccess() -> Bool {
        let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
        let options = [checkOptPrompt: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary?)
        return accessEnabled
    }
    
    public func launchAnotherInstance() {
        let path = Bundle.main.bundleURL.path
        Shell.execute("open", "-n", path)
    }
}

#endif
