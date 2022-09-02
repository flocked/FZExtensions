//
//  FileTypeDefinition.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//


#if canImport(UniformTypeIdentifiers)
import Foundation
import UniformTypeIdentifiers

@available(macOS 11.0, iOS 14.0, *)
public struct FileTypeDefinition: Codable, Hashable {
    var iconName: String?
    var name: String?
    var role: String?
  //  var isPackage: Bool?
    var applicationURL: URL?
    @DefaultEmptyArray var extensions: [String]
    @DefaultEmptyArray private var contentTypeIdentifiers: [String]
    var contentTypes: [UTType] {
        return contentTypeIdentifiers.compactMap({UTType($0)})
    }
    
    private enum CodingKeys : String, CodingKey {
        case extensions = "CFBundleTypeExtensions"
        case iconName = "CFBundleTypeIconFile"
        case name = "CFBundleTypeName"
        case applicationURL = "ApplicationBundleURL"
        case role = "CFBundleTypeRole"
        case contentTypeIdentifiers = "LSItemContentTypes"
    }
    
    /*
    var applicationBundle: ApplicationBundle? {
        if let applicationURL = applicationURL {
            return ApplicationBundle(url: applicationURL)
        } else {
            return nil
        }
    }*/
    
}

#endif
