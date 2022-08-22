import Foundation
#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

public extension Path {
    typealias Predicate = ((Path) -> Bool)
    
    /// The builder for `Path.find()`
    class Finder {
        @available(macOS 11.0, *)
        fileprivate init(path: Path, types: [Path.EntryType]? = nil, contenttypes: [UTType]? = nil) {
            self.path = path
            self.contentTypeIDs = nil
            if let value = contenttypes?.compactMap({$0.identifier}) {
                self.contentTypeIDs = Set(value)
            }
            self.enumerator = FileManager.default.enumerator(at: URL(fileURLWithPath: path.path), includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsPackageDescendants])
        }
        
        fileprivate init(path: Path, types: [Path.EntryType]? = nil, contenTypeIDs: [String]? = nil) {
            self.path = path
            self.contentTypeIDs = nil
            if let value = contenTypeIDs {
                self.contentTypeIDs = Set(value)
            }
            self.enumerator = FileManager.default.enumerator(at: URL(fileURLWithPath: path.path), includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsPackageDescendants])
        }

        /// The `path` find operations operate on.
        public let path: Path
        
        /// The  types of paths find operations should skip.
        private(set) public var skip: SkipOptions = [.hiddenFiles, .packageDescendants] {
            didSet {
                updateEnumarator()
            }
        }
        
        public struct SkipOptions: OptionSet {
            public static let packageDescendants = SkipOptions(rawValue: 1)
            public  static let hiddenFiles = SkipOptions(rawValue: 1 << 1)
            public let rawValue: Int8
            public init(rawValue: Int8) {
                self.rawValue = rawValue
            }
        }
        
        private(set) public var urlResources = Set<URLResourceKey>() {
            didSet {
                self.updateEnumarator()
            }
        }
        
        private(set) public var filter: Predicate? = nil
        
       private func updateEnumarator() {
           var options = FileManager.DirectoryEnumerationOptions()
            if (skip.contains(.hiddenFiles)) {  options.insert(.skipsHiddenFiles) }
            if (skip.contains(.packageDescendants)) {  options.insert(.skipsPackageDescendants) }
           self.enumerator = FileManager.default.enumerator(at: URL(fileURLWithPath: path.path), includingPropertiesForKeys: Array(urlResources), options: options)
        }
        
        private var enumerator: FileManager.DirectoryEnumerator!

        /// The range of directory depths for which the find operation will return entries.
        private(set) public var depth: ClosedRange<Int> = 1...Int.max {
            didSet {
                if depth.lowerBound < 0 {
                    depth = 0...depth.upperBound
                }
            }
        }

        /// The kinds of filesystem entries find operations will return.
        public var types: Set<EntryType> {
            get {
                return _types ?? Set(EntryType.allCases)
            }
        }

        private var _types: Set<EntryType>?
        
        /// The content types find operations will return.
        private(set) public var contentTypeIDs: Set<String>? {
            didSet {
                if let contentTypes = contentTypeIDs, contentTypes.isEmpty == false {
                    self.urlResources.insert(.fileResourceIdentifierKey)
                } else {
                    self.urlResources.remove(.fileResourceIdentifierKey)
                }
            }
        }
        
        @available(macOS 11.0, *)
        private var contentTypes: [UTType]? {
           return contentTypeIDs?.compactMap({UTType($0)})
        }
         

        /// The file extensions find operations will return. Files *and* directories unless you filter for `kinds`.
        private(set) public var extensions: Set<String>?
        
    }
}

extension Path.Finder: Sequence, IteratorProtocol {
    
    private func contentTypeID(_ id: String, conformsTo conformID: String) -> Bool {
       return UTTypeConformsTo(id as CFString, conformID as CFString)
    }
    
    
    private func contentTypeID(_ id: String, conformstoAny conformIDs: [String]) -> Bool {
        for conformID in conformIDs {
            if (self.contentTypeID(id, conformsTo: conformID)) {
                return true
            }
        }
       return false
    }
    
    public func next() -> Path? {
        guard let enumerator = enumerator else {
            return nil
        }
        while let relativePath = enumerator.nextObject() as? URL {
            let path = Path(url: relativePath)!
            
            if enumerator.level > depth.upperBound {
                enumerator.skipDescendants()
                continue
            }
            if enumerator.level < depth.lowerBound {
                continue
            }
             

            /*
            guard let resourceValues = try? relativePath.resourceValues(forKeys: self.urlResourceKeys),
                  let isDirectory = resourceValues.isDirectory,
                  let isRegularFile = resourceValues.isRegularFile,
                let isSymLink = resourceValues.isSymbolicLink
                  else {
                      continue
              }
            */
            
            if let filter = self.filter, !filter(path) { continue }
            if let type = path.type, !types.contains(type) { continue }
            if #available(macOS 11.0, *) {
                if let contentTypes = contentTypes, let contentType = path.contentType, !contentType.conforms(toAny: contentTypes){ continue }
            } else {
                if let contentTypes = contentTypeIDs, let contentTypeID = path.contentTypeID, !self.contentTypeID(contentTypeID, conformstoAny: Array(contentTypes)){ continue }
            }
            
            if let exts = extensions, !exts.contains(path.extension.lowercased()) { continue }
            
            return path
        }
        return nil
    }

    public typealias Element = Path
}

public extension Path.Finder {
    /// A max depth of `0` returns only the path we are searching, `1` is that directory’s listing.
    func depth(max maxDepth: Int) -> Path.Finder {
        depth = Swift.min(maxDepth, depth.lowerBound)...maxDepth
        return self
    }

    /// A min depth of `0` also returns the path we are searching, `1` is that directory’s listing. Default is `1` thus not returning ourself.
    func depth(min minDepth: Int) -> Path.Finder {
        depth = minDepth...Swift.max(depth.upperBound, minDepth)
        return self
    }

    /// A max depth of `0` returns only the path we are searching, `1` is that directory’s listing.
    /// A min depth of `0` also returns the path we are searching, `1` is that directory’s listing. Default is `1` thus not returning ourself.
    func depth(_ rng: Range<Int>) -> Path.Finder {
        depth = rng.lowerBound...(rng.upperBound - 1)
        return self
    }

    /// A max depth of `0` returns only the path we are searching, `1` is that directory’s listing.
    /// A min depth of `0` also returns the path we are searching, `1` is that directory’s listing. Default is `1` thus not returning ourself.
    func depth(_ rng: ClosedRange<Int>) -> Path.Finder {
        depth = rng
        return self
    }
    
    func filter(_ predicate: @escaping ((Element) -> Bool)) -> Path.Finder {
        self.filter = predicate
        return self
    }
        
    func files() -> Path.Finder {
        _types = [.file]
        return self
    }
    
    func directories() -> Path.Finder {
        _types = [.directory]
        return self
    }
    
    func skip(_ options: SkipOptions...) -> Path.Finder {
        var skipOptions = SkipOptions()
        for option in options {
            skipOptions.insert(option)
        }
        self.skip = skipOptions
        return self
    }
    
    func urlResources(_ keys: URLResourceKey...) -> Path.Finder {
        for key in keys {
            self.urlResources.insert(key)
        }
        return self
    }
    
    /// Multiple calls will configure the Finder with multiple kinds.
    func type(_ type: Path.EntryType) -> Path.Finder {
        _types = _types ?? []
        _types!.insert(type)
        return self
    }
    
    /// Multiple calls will configure the Finder with multiple kinds.
    func types(_ types: Path.EntryType...) -> Path.Finder {
        _types = _types ?? []
        for type in types {
            _types!.insert(type)
        }
        return self
    }

    /// Multiple calls will configure the Finder with for multiple extensions
    func `extension`(_ ext: String) -> Path.Finder {
        extensions = extensions ?? []
        extensions!.insert(ext.lowercased())
        return self
    }
    
    /// Multiple calls will configure the Finder with for multiple extensions
    func extensions (_ exts: String...) -> Path.Finder {
        extensions = extensions ?? []
        for ext in exts {
            extensions!.insert(ext.lowercased())
        }
        return self
    }
    
    @available(macOS 11.0, *)
    func contentType(_ type: UTType) -> Path.Finder {
        contentTypeIDs = contentTypeIDs ?? []
        contentTypeIDs!.insert(type.identifier)
        return self
    }
    
    @available(macOS 11.0, *)
    func contentTypes(_ types: UTType...) -> Path.Finder {
        contentTypeIDs = contentTypeIDs ?? []
        for type in types {
            contentTypeIDs!.insert(type.identifier)
        }
        return self
    }
    

    /// The return type for `Path.Finder`
    enum ControlFlow {
        /// Stop enumerating this directory, return to the parent.
        case skip
        /// Stop enumerating all together.
        case abort
        /// Keep going.
        case `continue`
    }

    /// Enumerate, one file at a time.
    func execute(_ closure: (Path) throws -> ControlFlow) rethrows {
        while let path = next() {
            switch try closure(path) {
            case .skip:
                enumerator.skipDescendants()
            case .abort:
                return
            case .continue:
                continue
            }
        }
    }
}

public extension Pathish {

    //MARK: Directory Listing

    /**
     Same as the `ls` command ∴ output is ”shallow” and unsorted.
     - Note: as per `ls`, by default we do *not* return hidden files. Specify `.a` for hidden files.
     - Parameter options: Configure the listing.
     - Important: On Linux the listing is always `ls -a`
     */
    func ls(_ options: ListDirectoryOptions? = nil) -> [Path] {
        guard let urls = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else {
            fputs("warning: could not list: \(self)\n", stderr)
            return []
        }
        return urls.compactMap { url in
            guard let path = Path(url.path) else { return nil }
            if options != .a, path.basename().hasPrefix(".") { return nil }
            // ^^ we don’t use the Foundation `skipHiddenFiles` because it considers weird things hidden and we are mirroring `ls`
            return path
        }.sorted()
    }

    func find() -> Path.Finder {
        return .init(path: Path(self))
    }
    
    /// Recursively find files under this path. If the path is a file, no files will be found.
    func find(_ types: Path.EntryType...) -> Path.Finder {
        return .init(path: Path(self), types: types)
    }
    
    @available(macOS 11.0, *)
    func find(_ contenttypes: UTType...) -> Path.Finder {
        return .init(path: Path(self), contenttypes: contenttypes)
    }
}

/// Convenience functions for the arrays of `Path`
public extension Array where Element == Path {
    /// Filters the list of entries to be a list of Paths that are directories. Symlinks to directories are not returned.
    var directories: [Path] {
        return filter {
            $0.isDirectory
        }
    }

    /// Filters the list of entries to be a list of Paths that exist and are *not* directories. Thus expect symlinks, etc.
    /// - Note: symlinks that point to files that do not exist are *not* returned.
    var files: [Path] {
        return filter {
            switch $0.type {
            case .none, .directory?:
                return false
            case .file?, .symlink?:
                return true
            }
        }
    }
}

/// Options for `Path.ls(_:)`
public enum ListDirectoryOptions {
    /// Lists hidden files also
    case a
}
