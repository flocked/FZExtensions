//
//  NSWorkspace+ApplicationBundle.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//


#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

#if os(macOS)

import Foundation
import AppKit

public extension NSWorkspace {
    @available(macOS 12.0, *)
    func applications(toOpen fileExtension: String) -> [ApplicationBundle] {
        if let uttype = UTType(filenameExtension: fileExtension.lowercased()) {
            return applications(toOpen: uttype)
        }
        return []
    }
    
    @available(macOS 12.0, *)
    func applications(toOpen uttype: UTType) -> [ApplicationBundle] {
        self.urlsForApplications(toOpen: uttype).compactMap({ApplicationBundle(url: $0)})
    }
    
    /*
    func fileDefinitions(for fileExtension: String) -> [FileTypeDefinition] {
        if let uttype = UTType(filenameExtension: fileExtension.lowercased()) {
            return fileDefinitions(for: uttype)
        }
        return []
    }

    func fileDefinitions(for uttype: UTType) -> [FileTypeDefinition] {
       let bundles = self.urlsForApplications(toOpen: uttype).compactMap({ApplicationBundle(url: $0)})
        var definitions = [FileTypeDefinition]()
        for bundle in bundles {
           let types = bundle.supportedFileTypes.filter({uttype.conforms(toAny: $0.contentTypes)})
            definitions.append(contentsOf: types)
        }
        return definitions
    }
     */
    
}

#endif
