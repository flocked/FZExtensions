//
//  File.swift
//  
//
//  Created by Florian Zand on 30.11.22.
//

#if os(macOS)
import AppKit
import QuickLookThumbnailing

public extension QLThumbnailGenerator.Request {
    var fileURL: URL {
        get { self.value(forKey: "fileURL") as! URL }
        set { self.setValue(newValue, forKey: "fileURL") }
    }
}

#endif
