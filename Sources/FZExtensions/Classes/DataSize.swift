import Foundation

public struct DataSize: Comparable, Equatable {
    typealias CountStyle = ByteCountFormatter.CountStyle
    var countStyle: CountStyle
    
    init(_ bytes: Int, countStyle: CountStyle = .file) {
        self.bytes = bytes
        self.countStyle = countStyle
    }
        
    init(terabytes: Double = 0, gigabytes: Double = 0, megabytes: Double = 0, kilobytes: Double = 0, bytes: Int = 0, countStyle: CountStyle = .file) {
        self.bytes = bytes
        self.countStyle = countStyle
        self.bytes += self.bytes(for: kilobytes, .kilobyte)
        self.bytes += self.bytes(for: megabytes, .megabyte)
        self.bytes += self.bytes(for: gigabytes, .gigabyte)
        self.bytes += self.bytes(for: terabytes, .terabyte)
    }
    
    var bytes: Int
    
    var kilobytes: Double {
        get { value(for: .kilobyte) }
        set { self.bytes = bytes(for: newValue, .kilobyte) }
    }
    
    var megabytes: Double {
        get { value(for: .megabyte) }
        set { self.bytes = bytes(for: newValue, .megabyte) }
    }
    
    var gigabytes: Double {
        get { value(for: .gigabyte) }
        set { self.bytes = bytes(for: newValue, .gigabyte) }
    }
    
    var terabytes: Double {
        get { value(for: .terabyte) }
        set { self.bytes = bytes(for: newValue, .terabyte) }
    }
    
    var petabytes: Double {
        get { value(for: .petabyte) }
        set { self.bytes = bytes(for: newValue, .petabyte) }
    }
    
    private func value(for unit: Unit) -> Double {
        Unit.byte.convert(Double(self.bytes), to: unit, countStyle: self.countStyle)
    }
    
    private func bytes(for value: Double, _ unit: Unit) -> Int {
        Int(unit.self.convert(value, to: .byte, countStyle: self.countStyle))
    }
}

public extension DataSize {
    enum Unit: Int {
        case byte = 0
        case kilobyte = 1
        case megabyte = 2
        case gigabyte = 3
        case terabyte = 4
        case petabyte = 5
        case exabyte = 6
        case zettabyte = 7
        case yottabyte = 8
       
       fileprivate var byteCountFormatterUnit: ByteCountFormatter.Units {
           switch self {
           case .byte:
               return .useBytes
           case .kilobyte:
               return .useKB
           case .megabyte:
               return .useMB
           case .gigabyte:
               return .useGB
           case .terabyte:
               return .useTB
           case .petabyte:
               return .usePB
           case .exabyte:
               return .useEB
           case .zettabyte:
               return .useZB
           case .yottabyte:
               return .useYBOrHigher
           }
       }
        
        func convert(_ number: Double, to targetUnit: Unit, countStyle: CountStyle = .file) -> Double {
            let factor: Double = (countStyle == .binary) ? 1024 : 1000
            let conversionFactor = pow(factor, Double(self.rawValue - targetUnit.rawValue))
            return number * conversionFactor
        }
    }
}

public extension DataSize {
    static func -(lhs: Self, rhs: Self) -> Self {
        var bytes = lhs.bytes-rhs.bytes
        if (bytes < 0) { bytes = 0 }
       return Self(bytes, countStyle: lhs.countStyle)
    }
    
    static func +(lhs: Self, rhs: Self) -> Self {
        Self(lhs.bytes+rhs.bytes, countStyle: lhs.countStyle)
    }
    
    static func -=(lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
    
    static func +=(lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.bytes == rhs.bytes
    }
    
    static func !=(lhs: Self, rhs: Self) -> Bool {
        return lhs.bytes != rhs.bytes
    }
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        return lhs.bytes < rhs.bytes
    }
}

extension DataSize: CustomStringConvertible {
    public  var description: String {
        let formatter = self.formatter
        formatter.includesActualByteCount = true
        return formatter.string(fromByteCount: Int64(self.bytes))
    }
    
    private var formatter: ByteCountFormatter {
        return ByteCountFormatter(unit: .useAll, countStyle: self.countStyle)
    }
    
    public var string: String {
        return string()
    }
    
    public func string(for unit: Unit, includesUnit: Bool = true) -> String {
        return self.string(allowedUnits: unit.byteCountFormatterUnit, includesUnit: includesUnit)
    }
    
    public func string(allowedUnits: ByteCountFormatter.Units = .useAll, includesUnit: Bool = true) -> String {
       let formatter = self.formatter
       formatter.allowedUnits = allowedUnits
       formatter.includesUnit = includesUnit
       return formatter.string(fromByteCount: Int64(self.bytes))
    }
}
