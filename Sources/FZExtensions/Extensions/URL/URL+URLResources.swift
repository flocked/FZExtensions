//
//  URL+Resource.swift
//  FinalImageCollectionView
//
//  Created by Florian Zand on 25.12.21.
//

import Foundation
import UniformTypeIdentifiers

public extension URL {
     var resources: URLResources {
        return URLResources(url: self)
    }
}

public class URLResources {
    var url: URL
    init(url: URL) {
        self.url = url
    }

    public var name: String? {
        get {
            return try? url.resourceValues(forKeys: [.nameKey]).name
         }
        set {
            var urlResouceValues = URLResourceValues()
            urlResouceValues.name = newValue
            try? url.setResourceValues(urlResouceValues)
        }
    }

        public var localizedName: String? {
            get {
                return try? url.resourceValues(forKeys: [.localizedNameKey]).localizedName
             }
        }

        public var isRegularFile: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) ?? false
             }
        }

        public var isDirectory: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false
             }
        }

        public var isSymbolicLink: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isSymbolicLinkKey]).isSymbolicLink) ?? false
             }
        }
    

        public var isVolume: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isVolumeKey]).isVolume) ?? false
             }
        }
    
    public var volumeName: String? {
        get {
            return try? url.resourceValues(forKeys: [.volumeNameKey]).volumeName
         }
        set {
            if let newValue = newValue {
                var urlResouceValues = URLResourceValues()
                urlResouceValues.volumeName = newValue
                try? url.setResourceValues(urlResouceValues)
            }
        }
    }
    
    public var volumeURL: URL? {
        get {
            return try? url.resourceValues(forKeys: [.volumeURLKey]).volume
         }
    }

        public var isPackage: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isPackageKey]).isPackage) ?? false
             }
            set {
                var urlResouceValues = URLResourceValues()
                urlResouceValues.isPackage = newValue
                try? url.setResourceValues(urlResouceValues)
            }
        }

        @available(macOS 10.11, iOS 9.0, *)
        public var isApplication: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isApplicationKey]).isApplication) ?? false
             }
        }

        /// True if the resource is scriptable. Only applies to applications.
        @available(macOS 10.11, *)
        public var applicationIsScriptable: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.applicationIsScriptableKey]).applicationIsScriptable) ?? false
             }
        }

        /// True for system-immutable resources.
        public var isSystemImmutable: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isSystemImmutableKey]).isSystemImmutable) ?? false
             }
        }

        /// True for user-immutable resources
        public var isUserImmutable: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isUserImmutableKey]).isUserImmutable) ?? false
             }
            set {
                 var urlResouceValues = URLResourceValues()
                 urlResouceValues.isUserImmutable = newValue
                 try? url.setResourceValues(urlResouceValues)
             }
        }

  
        public var isHidden: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isHiddenKey]).isHidden) ?? false
             }
            set {
                var urlResouceValues = URLResourceValues()
                urlResouceValues.isHidden = newValue
                try? url.setResourceValues(urlResouceValues)
            }
        }
        public var hasHiddenExtension: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.hasHiddenExtensionKey]).hasHiddenExtension) ?? false
             }
            set {
                var urlResouceValues = URLResourceValues()
                urlResouceValues.hasHiddenExtension = newValue
                try? url.setResourceValues(urlResouceValues)
            }
        }
    
        public var creationDate: Date? {
            get {
                return try? url.resourceValues(forKeys: [.creationDateKey]).creationDate
             }
            set {
                var urlResouceValues = URLResourceValues()
                urlResouceValues.creationDate = newValue
                try? url.setResourceValues(urlResouceValues)
            }
        }
    
    public var addedToDirectoryDateKey: Date? {
        get {
            return try? url.resourceValues(forKeys: [.addedToDirectoryDateKey]).addedToDirectoryDate
         }
    }
    
        public var lastAccessDate: Date? {
            get {
                return try? url.resourceValues(forKeys: [.contentAccessDateKey]).contentAccessDate
             }
            set {
                var urlResouceValues = URLResourceValues()
                urlResouceValues.contentAccessDate = newValue
                try? url.setResourceValues(urlResouceValues)
            }
        }
    
        public var modificationDate: Date? {
            get {
                return try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
             }
            set {
                var urlResouceValues = URLResourceValues()
                urlResouceValues.contentModificationDate = newValue
                try? url.setResourceValues(urlResouceValues)
            }
        }

        public var attributeModificationDate: Date? {
            get {
                return try? url.resourceValues(forKeys: [.attributeModificationDateKey]).attributeModificationDate
             }
        }

        public var linkCount: Int? {
            get {
                return try? url.resourceValues(forKeys: [.linkCountKey]).linkCount
             }
        }
    
        public var parentDirectory: URL? {
            get {
                return try? url.resourceValues(forKeys: [.parentDirectoryURLKey]).parentDirectory
             }
            set {
                if var newParentDirectory = newValue {
                    newParentDirectory.appendPathComponent(self.url.lastPathComponent)
                    try? FileManager.default.moveItem(at: self.url, to: newParentDirectory)
                }
            }
        }

        public var localizedTypeDescription: String? {
            get {
                return try? url.resourceValues(forKeys: [.localizedTypeDescriptionKey]).localizedTypeDescription
             }
        }

        /// The label number assigned to the resource.
        public var labelNumber: Int? {
            get {
                return try? url.resourceValues(forKeys: [.labelNumberKey]).labelNumber
             }
            set {
                var urlResouceValues = URLResourceValues()
                urlResouceValues.labelNumber = newValue
                try? url.setResourceValues(urlResouceValues)
            }
        }
    
        public var localizedLabel: String? {
            get {
                return try? url.resourceValues(forKeys: [.localizedLabelKey]).localizedLabel
             }
        }
     

        /// A 64-bit value assigned by APFS that identifies a file's content data stream. Only cloned files and their originals can have the same identifier.
        @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
        public var fileContentIdentifier: Int64? {
            get {
                return try? url.resourceValues(forKeys: [.fileContentIdentifierKey]).fileContentIdentifier
             }
        }

        public var preferredIOBlockSize: Int? {
            get {
                return try? url.resourceValues(forKeys: [.preferredIOBlockSizeKey]).preferredIOBlockSize
             }
        }

        public var isReadable: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isReadableKey]).isReadable) ?? false
             }
        }
        public var isWritable: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isWritableKey]).isWritable) ?? false
             }
        }
        public var isExecutable: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isExecutableKey]).isExecutable) ?? false
             }
        }
    
        public var fileSecurity: NSFileSecurity? {
            get {
                return try? url.resourceValues(forKeys: [.fileSecurityKey]).fileSecurity
             }
        }
    
        public var isExcludedFromBackup: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isExcludedFromBackupKey]).isExcludedFromBackup) ?? false
             }
            set {
                var urlResouceValues = URLResourceValues()
                urlResouceValues.isExcludedFromBackup = newValue
                try? url.setResourceValues(urlResouceValues)
            }
        }
    
        public var path: String? {
            get {
                return try? url.resourceValues(forKeys: [.pathKey]).path
             }
        }

        @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
        public var canonicalPath: String? {
            get {
                return try? url.resourceValues(forKeys: [.canonicalPathKey]).canonicalPath
             }
        }

        public var isMountTrigger: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isMountTriggerKey]).isMountTrigger) ?? false
             }
        }

        @available(macOS 10.10, iOS 8.0, *)
        public var generationIdentifier: (NSCopying & NSSecureCoding & NSObjectProtocol)? {
            get {
                return try? url.resourceValues(forKeys: [.generationIdentifierKey]).generationIdentifier
             }
        }

        @available(macOS 10.10, iOS 8.0, *)
        public var documentIdentifier: Int? {
            get {
                return try? url.resourceValues(forKeys: [.documentIdentifierKey]).documentIdentifier
             }
        }

        @available(macOS 10.10, iOS 8.0, *)
        public var addedToDirectoryDate: Date? {
            get {
                return try? url.resourceValues(forKeys: [.addedToDirectoryDateKey]).addedToDirectoryDate
             }
        }

        @available(macOS 10.10, *)
        public var quarantineProperties: [String : Any]? {
            get {
                return try? url.resourceValues(forKeys: [.quarantinePropertiesKey]).quarantineProperties
             }
            set {
                var urlResouceValues = URLResourceValues()
                urlResouceValues.quarantineProperties = newValue
                try? url.setResourceValues(urlResouceValues)
            }
        }

        @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
        public var mayHaveExtendedAttributes: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.mayHaveExtendedAttributesKey]).mayHaveExtendedAttributes) ?? false
             }
        }

        @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
        public var isPurgeable: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isPurgeableKey]).isPurgeable) ?? false
             }
        }

        @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
        public var isSparse: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isSparseKey]).isSparse) ?? false
             }
        }

        @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
        public var mayShareFileContent: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.mayShareFileContentKey]).mayShareFileContent) ?? false
             }
        }

        public var fileResourceType: URLFileResourceType? {
            get {
                return try? url.resourceValues(forKeys: [.fileResourceTypeKey]).fileResourceType
             }
        }

        public var isUbiquitousItem: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isUbiquitousItemKey]).isUbiquitousItem) ?? false
             }
        }
        public var ubiquitousItemHasUnresolvedConflicts: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.ubiquitousItemHasUnresolvedConflictsKey]).ubiquitousItemHasUnresolvedConflicts) ?? false
             }
        }
        public var ubiquitousItemIsDownloading: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.ubiquitousItemIsDownloadingKey]).ubiquitousItemIsDownloading) ?? false
             }
        }
        public var ubiquitousItemIsUploaded: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.ubiquitousItemIsUploadedKey]).ubiquitousItemIsUploaded) ?? false
             }
        }
        public var ubiquitousItemIsUploading: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.ubiquitousItemIsUploadingKey]).ubiquitousItemIsUploading) ?? false
             }
        }
        public var ubiquitousItemDownloadingStatus: URLUbiquitousItemDownloadingStatus? {
            get {
                return try? url.resourceValues(forKeys: [.ubiquitousItemDownloadingStatusKey]).ubiquitousItemDownloadingStatus
             }
        }

        @available(macOS 11.0, iOS 9.0, *)
        public var fileProtection: URLFileProtection? {
            get {
                return try? url.resourceValues(forKeys: [.fileProtectionKey]).fileProtection
             }
        }
    
        public var fileSize: Int? {
            get {
                return try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize
             }
        }
    
        public var fileAllocatedSize: Int? {
            get {
                return try? url.resourceValues(forKeys: [.fileAllocatedSizeKey]).fileAllocatedSize
             }
        }
    
        public var totalFileSize: Int? {
            get {
                return try? url.resourceValues(forKeys: [.totalFileSizeKey]).totalFileSize
             }
        }
    
        public var totalFileAllocatedSize: Int? {
            get {
                return try? url.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize
             }
        }
    
    
        public var isAliasFile: Bool {
            get {
                return (try? url.resourceValues(forKeys: [.isAliasFileKey]).isAliasFile) ?? false
             }
        }
        
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    public  var contentType: UTType? {
        get {
           return try? url.resourceValues(forKeys: [.contentTypeKey]).contentType
        }
    }
    
    }

extension URLResources {
    var dataSize: DataSize? {
        if let bytes = self.totalFileAllocatedSize ?? self.fileAllocatedSize {
            return DataSize(bytes)
        }
        return nil
    }
}

#if os(macOS)
import AppKit
extension URLResources {
        public var tags: [String] {
            get {
                if let tagNames = try? url.resourceValues(forKeys: [.tagNamesKey]).tagNames {
                    return tagNames
                }
                return []
             }
            set {
                do {
                    let fileLabels = NSWorkspace.shared.fileLabels
                    if (fileLabels.contains(all: newValue) == true) {
                        let url = self.url as NSURL
                        try url.setResourceValue(newValue.unique() as NSArray, forKey: .tagNamesKey)
                    }
                } catch {
                    print("Can not set tagNames")
                }
            }
        }
}
#endif
