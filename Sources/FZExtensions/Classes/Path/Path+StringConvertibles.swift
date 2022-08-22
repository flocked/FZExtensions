extension Path: CustomStringConvertible {    
    /// Returns `Path.string`
    public var description: String {
        return path
    }
}

extension Path: CustomDebugStringConvertible {
    /// Returns eg. `Path(string: "/foo")`
    public var debugDescription: String {
        return "Path(\(path))"
    }
}

extension DynamicPath: CustomStringConvertible {
    /// Returns `Path.string`
    public var description: String {
        return path
    }
}

extension DynamicPath: CustomDebugStringConvertible {
    /// Returns eg. `Path(string: "/foo")`
    public var debugDescription: String {
        return "Path(\(path))"
    }
}
