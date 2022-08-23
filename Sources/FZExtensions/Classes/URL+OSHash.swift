import Foundation

public extension URL {
    func osHash() throws -> Hash.OSHash {
        return try Hash.OSHash(url: self)
    }
}

protocol HashValue: Equatable {
    var fileSize: UInt64 {get}
    var value: String {get}
}

 extension HashValue {
     public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value && lhs.fileSize == rhs.fileSize
    }
}

public class Hash {
    enum HashError: Error {
        case invalidFileURL
        case fileToSmall
    }
    public class OSHash: HashValue {
        
        private static let chunkSize: Int = 65536
        private static let UInt64Size = 8
        
        var value: String
        var fileSize: UInt64
        
        convenience init(url: URL) throws {
           try self.init(path: url.path)
        }
        
        init(path: String) throws {
            guard let fileHandler = FileHandle(forReadingAtPath: path) else {
                throw HashError.invalidFileURL
            }
            let fileDataBegin: Data = fileHandler.readData(ofLength: OSHash.chunkSize) as Data
            fileHandler.seekToEndOfFile()
            
            let fileSize: UInt64 = fileHandler.offsetInFile
            guard (UInt64(OSHash.chunkSize) <= fileSize) else {
                fileHandler.closeFile()
                throw HashError.fileToSmall
            }
            
            fileHandler.seek(toFileOffset: max(0, fileSize - UInt64(OSHash.chunkSize)))
            var hash: UInt64 = fileSize
            
            let fileDataEnd: Data = fileHandler.readData(ofLength: OSHash.chunkSize)
            
            fileDataBegin.withUnsafeBytes { buffer in
                let binded = buffer.bindMemory(to: UInt64.self)
                let data_bytes = UnsafeBufferPointer<UInt64>(
                    start: binded.baseAddress,
                    count: fileDataBegin.count/OSHash.UInt64Size)
                hash = data_bytes.reduce(into: hash,  { hash = $0 &+ $1 })
            }
            
            fileDataEnd.withUnsafeBytes { buffer in
                let binded = buffer.bindMemory(to: UInt64.self)
                let data_bytes = UnsafeBufferPointer<UInt64>(
                    start: binded.baseAddress,
                    count: fileDataEnd.count/OSHash.UInt64Size)
                hash = data_bytes.reduce(into: hash,  { hash = $0 &+ $1 })
            }
            
            self.value = String(format:"%qx", arguments: [hash])
            self.fileSize = fileSize
            fileHandler.closeFile()
        }
    }
}
