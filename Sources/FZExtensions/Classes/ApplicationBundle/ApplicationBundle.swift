//
//  ApplicationBundle.swift
//  ATest
//
//  Created by Florian Zand on 15.01.22.
//



#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

#if os(macOS)

import Foundation
import AppKit

public extension NSRunningApplication {
    var bundle: ApplicationBundle? {
        return ApplicationBundle(runningApplication: self)
    }
}

public class ApplicationBundle: Bundle {
    override init?(path: String) {
        super.init(path: path)
        if (self.infoURL?.fileExists == false || !self.isApplicationBundle) {
           return nil
        }
    }
    
    convenience init?(url: URL) {
        self.init(path: url.path)
    }
    
    convenience init?(runningApplication: NSRunningApplication) {
        if let path = runningApplication.bundleURL?.path {
            self.init(path: path)
        } else {
            return nil
        }
    }
    
    lazy private var info: ApplicationInfo = {
        return ApplicationInfo(dic: self.infoDictionary!)!
       }()
        
    var name: String {
        if let name = info.name {
            return name
        } else if let displayName = info.displayName {
            return displayName
        }
        return bundleNameExcludingExtension
    }
    
    var displayName: String {
        if let displayName = info.displayName {
           return displayName
        }
        return name
    }
    
    var iconURL: URL? {
        if let iconFile = info.iconFile {
          return  self.urlForImageResource(iconFile)
        }
        if let iconName = info.iconName {
          return  self.urlForImageResource(iconName)
        }
        return nil
    }
    
    var iconPath: String? {
        return iconURL?.path
    }
    
    var shortVersion: String? {
        return info.shortVersion
    }
    
    var version: String? {
        return info.version
    }
    
    var isRunning: Bool {
        if let bundleIndentifer = self.bundleIdentifier, NSRunningApplication.runningApplications(withBundleIdentifier: bundleIndentifer).isEmpty == false {
            return true
        }
        return false
    }

    
    @available(macOS 11.0, iOS 14.0, *)
    var supportedFileTypes: [FileTypeDefinition] {
        return info.supportedFileTypes 
    }
    
    @available(macOS 11.0, iOS 14.0, *)
    var supportedFileExtensions: [String] {
        return (supportedFileTypes.flatMap({$0.extensions})).unique().sorted()
    }
 

    func open() {
        NSWorkspace.shared.openApplication(at: self.bundleURL, configuration: .init(), completionHandler: nil)
    }
    
    func openFile(_ url: URL) {
        NSWorkspace.shared.open([url], withApplicationAt: self.bundleURL, configuration: NSWorkspace.OpenConfiguration())
    }
    
    func openFiles(_ urls: [URL]) {
        NSWorkspace.shared.open(urls, withApplicationAt: self.bundleURL, configuration: NSWorkspace.OpenConfiguration())
    }
    
    @available(macOS 11.0, iOS 14.0, *)
    func fileTypeDefinition(for type: UTType) -> FileTypeDefinition? {
       return supportedFileTypes.first(where: {type.conforms(toAny: $0.contentTypes)})
    }
    
    @available(macOS 11.0, iOS 14.0, *)
    func fileTypeDefinition(for extensionString: String) -> FileTypeDefinition? {
        return supportedFileTypes.first(where: {$0.extensions.contains(extensionString.lowercased())})
    }
}

#endif
