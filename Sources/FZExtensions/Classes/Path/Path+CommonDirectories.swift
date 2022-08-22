import Foundation

/// The `extension` that provides static properties that are common directories.
private enum Foo {
    //MARK: Common Directories

    /// Returns a `Path` containing `FileManager.default.currentDirectoryPath`.
    static var cwd: DynamicPath {
        return .init(string: FileManager.default.currentDirectoryPath)
    }

    /// Returns a `Path` representing the root path.
    static var root: DynamicPath {
        return .init(string: "/")
    }

    public static func source(for filePath: String = #filePath) -> (file: DynamicPath, directory: DynamicPath) {
        let file = DynamicPath(string: filePath)
        return (file: file, directory: .init(file.parent))
    }


    /// Returns a `Path` representing the user’s home directory
    static var home: DynamicPath {
        let string: String
        if #available(OSX 10.12, *) {
            string = FileManager.default.homeDirectoryForCurrentUser.path
        } else {
            string = NSHomeDirectory()
        }
        return .init(string: string)
    }

    /// Helper to allow search path and domain mask to be passed in.
    private static func path(for searchPath: FileManager.SearchPathDirectory) -> DynamicPath {

        guard let pathString = FileManager.default.urls(for: searchPath, in: .userDomainMask).first?.path else { return defaultUrl(for: searchPath) }
        return DynamicPath(string: pathString)
    }

    /**
     The root for user documents.
     - Note: There is no standard location for documents on Linux, thus we return `~/Documents`.
     - Note: You should create a subdirectory before creating any files.
     */
    static var documents: DynamicPath {
        return path(for: .documentDirectory)
    }
    
    static var movies: DynamicPath {
        return path(for: .moviesDirectory)
    }
    
    static var pictures: DynamicPath {
        return path(for: .picturesDirectory)
    }
    
    static var downloads: DynamicPath {
        return path(for: .downloadsDirectory)
    }
    
    static var music: DynamicPath {
        return path(for: .musicDirectory)
    }
    
    static var applications: DynamicPath {
        return path(for: .applicationDirectory)
    }
    
    static var desktop: DynamicPath {
        return path(for: .desktopDirectory)
    }
    
    static var trash: DynamicPath {
        return path(for: .trashDirectory)
    }
    
    static var developer: DynamicPath {
        return path(for: .developerDirectory)
    }
    
    /**
     The root for cache files.
     - Note: On Linux this is `XDG_CACHE_HOME`.
     - Note: You should create a subdirectory before creating any files.
     */
    static var caches: DynamicPath {
        return path(for: .cachesDirectory)
    }

    /**
     For data that supports your running application.
     - Note: On Linux is `XDG_DATA_HOME`.
     - Note: You should create a subdirectory before creating any files.
     */
    static var applicationSupport: DynamicPath {
        return path(for: .applicationSupportDirectory)
    }
}

func defaultUrl(for searchPath: FileManager.SearchPathDirectory) -> DynamicPath {
    switch searchPath {
    case .documentDirectory:
        return Path.home.Documents
    case .applicationSupportDirectory:
        return Path.home.Library[dynamicMember: "Application Support"]
    case .cachesDirectory:
        return Path.home.Library.Caches
    default:
        fatalError()
    }
}

/// The `extension` that provides static properties that are common directories.
public extension Pathish where Self == Path {
    static var home: DynamicPath { return Foo.home }
    static var root: DynamicPath { return Foo.root }
    static var cwd: DynamicPath { return Foo.cwd }
    
    static var desktop: DynamicPath { return Foo.desktop }
    static var documents: DynamicPath { return Foo.documents }
    static var movies: DynamicPath { return Foo.movies }
    static var pictures: DynamicPath { return Foo.pictures }
    static var music: DynamicPath { return Foo.music }
    static var downloads: DynamicPath { return Foo.downloads }
    static var developer: DynamicPath { return Foo.developer }
    static var applications: DynamicPath { return Foo.applications }
    
    static var trash: DynamicPath { return Foo.trash }
    
    static var caches: DynamicPath { return Foo.caches }
    static var applicationSupport: DynamicPath { return Foo.applicationSupport }
    static func source(for filePath: String = #filePath) -> (file: DynamicPath, directory: DynamicPath) {
        return Foo.source(for: filePath)
    }
}
