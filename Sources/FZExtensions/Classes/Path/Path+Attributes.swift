import Foundation
import UniformTypeIdentifiers

public extension Pathish {
    //MARK: Filesystem Attributes

    /**
     Returns the creation-time of the file.
     - Note: Returns `nil` if there is no creation-time, this should only happen if the file doesn’t exist.
     - Important: On Linux this is filesystem dependendent and may not exist.
     */
    var creationDate: Date? {
        return url.resources.creationDate
    }
    
    /**
     Returns the modification-time of the file.
     - Note: If this returns `nil` and the file exists, something is very wrong.
     */
    var modificationDate: Date? {
        return url.resources.modificationDate
    }
    
    var lastAccessDate: Date? {
        return url.resources.lastAccessDate
    }
    
    /**
     Returns the size of the file.
     - Note: Returns `nil` if there is no creation-time, this should only happen if the file doesn’t exist.
     - Important: On Linux this is filesystem dependendent and may not exist.
     */
    var size: DataSize? {
        return url.resources.dataSize
    }
    

    /*
    func directorySize() -> DataSize? {
        return Shell.totalSize(for: self.path)

        /*
        var bytes = 0
        for path in  self.find().depth(min: 0).urlResources(.totalFileAllocatedSizeKey, .fileAllocatedSizeKey) {
            bytes += path.size?.bytes ?? 0
        }
        return DataSize(bytes)
         */
      }
     */
    
    /**
     Returns the size of the file.
     - Note: Returns `nil` if there is no creation-time, this should only happen if the file doesn’t exist.
     - Important: On Linux this is filesystem dependendent and may not exist.
     */
    var resources: URLResources {
        return url.resources
    }
    
   var metadata: URLMetadata? {
       return url.metadata
   }
    
    /**
     Returns the contentType of the file.
     - Note: Returns `nil` if there is no creation-time, this should only happen if the file doesn’t exist.
     - Important: On Linux this is filesystem dependendent and may not exist.
     */
    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    var contentType: UTType? {
        get {
            return url.resources.contentType
        }
    }
    
    var contentTypeID: String? {
        get {
            let ext = self.url.pathExtension.replacingOccurrences(of: "^\\.*", with: "",
                                                   options: .regularExpression)
             let fileType =
                UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                      ext as CFString, nil)
            return fileType?.takeRetainedValue() as? String
        }
    }

    /// The type of the entry.
    /// - SeeAlso: `Path.EntryType`
    var type: Path.EntryType? {
        var buf = stat()
        guard lstat(path, &buf) == 0 else {
            return nil
        }
        if buf.st_mode & S_IFMT == S_IFLNK {
            return .symlink
        } else if buf.st_mode & S_IFMT == S_IFDIR {
            return .directory
        } else {
            return .file
        }
    }

    /**
     Sets the file’s attributes using UNIX octal notation.

         Path.home.join("foo").chmod(0o555)
     */
    @discardableResult
    func chmod(_ octal: Int) throws -> Path {
        try FileManager.default.setAttributes([.posixPermissions: octal], ofItemAtPath: path)
        return Path(self)
    }

    //MARK: Filesystem Locking
    
    /**
     Applies the macOS filesystem “lock” attribute.
     - Note: If file is already locked, does nothing.
     - Note: If file doesn’t exist, throws.
     - Important: On Linux does nothing.
     */
    @discardableResult
    func lock() throws -> Path {
    #if !os(Linux)
        var attrs = try FileManager.default.attributesOfItem(atPath: path)
        let b = attrs[.immutable] as? Bool ?? false
        if !b {
            attrs[.immutable] = true
            try FileManager.default.setAttributes(attrs, ofItemAtPath: path)
        }
    #endif
        return Path(self)
    }

    /**
     - Note: If file isn‘t locked, does nothing.
     - Note: If file doesn’t exist, does nothing.
     - Important: On Linux does nothing.
     - SeeAlso: `lock()`
     */
    @discardableResult
    func unlock() throws -> Path {
    #if !os(Linux)
        var attrs: [FileAttributeKey: Any]
        do {
            attrs = try FileManager.default.attributesOfItem(atPath: path)
        } catch CocoaError.fileReadNoSuchFile {
            return Path(self)
        }
        let b = attrs[.immutable] as? Bool ?? false
        if b {
            attrs[.immutable] = false
            try FileManager.default.setAttributes(attrs, ofItemAtPath: path)
        }
    #endif
        return Path(self)
    }
}

/// The `extension` that provides `Kind`.
public extension Path {
    /// A filesystem entry’s kind, file, directory, symlink etc.
    enum EntryType: CaseIterable {
        /// The entry is a file.
        case file
        /// The entry is a symlink.
        case symlink
        /// The entry is a directory.
        case directory
        
        var resourceKey: URLResourceKey {
            switch self {
            case .file:
                return .isRegularFileKey
            case .symlink:
                return .isSymbolicLinkKey
            case .directory:
                return .isDirectoryKey
            }
        }
    }
}
