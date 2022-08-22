//
//  ImageOptions.swift
//  ATest
//
//  Created by Florian Zand on 02.06.22.
//

import Foundation

public struct ImageOptions : Codable {
    public var shouldCache: Bool? = true
    public var shouldDecodeImmediately: Bool? = nil
    public var subsampleFactor: SubsampleFactor? = nil
    public var shouldAllowFloat: Bool? = false

    public enum SubsampleFactor: Int, Codable {
        case factor2 = 2
        case factor4 = 4
        case factor8 = 8
    }
    
    public init(shouldCache: Bool? = true, shouldDecodeImmediately: Bool? = nil, subsampleFactor: SubsampleFactor? = nil, shouldAllowFloat: Bool? = false) {
        self.shouldCache = shouldCache
        self.shouldDecodeImmediately = shouldDecodeImmediately
        self.subsampleFactor = subsampleFactor
        self.shouldAllowFloat = shouldAllowFloat
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case shouldAllowFloat = "kCGImageSourceShouldAllowFloat"
        case shouldCache = "kCGImageSourceShouldCache"
        case shouldDecodeImmediately = "kCGImageSourceShouldCacheImmediately"
        case subsampleFactor = "kCGImageSourceSubsampleFactor"
    }
}

extension ImageOptions {
    public var dic: CFDictionary {
        var dic = [String: Any]()
        dic[CodingKeys.shouldAllowFloat.rawValue] = self.shouldAllowFloat
        dic[CodingKeys.shouldCache.rawValue] = self.shouldCache
        dic[CodingKeys.shouldDecodeImmediately.rawValue] = self.shouldDecodeImmediately
        dic[CodingKeys.subsampleFactor.rawValue] = self.subsampleFactor?.rawValue
        return dic as CFDictionary
    }
    
    public static func subsampleFactor(_ subsampleFactor: ImageOptions.SubsampleFactor) -> ImageOptions {
        return self.init(subsampleFactor: subsampleFactor)
    }
    
    public init(subsampleFactor: SubsampleFactor) {
        self.init(shouldCache: true, shouldDecodeImmediately: nil, subsampleFactor: subsampleFactor, shouldAllowFloat: false)
    }
}



/*
class Options: Codable {
    public var shouldCache: Bool? = true
    public var shouldDecodeImmediately: Bool? = nil
    public var subsampleFactor: SubsampleFactor? = nil
    public var shouldAllowFloat: Bool? = false

    public enum SubsampleFactor: Int, Codable {
        case factor2 = 2
        case factor4 = 4
        case factor8 = 8
    }
    
    public init(shouldCache: Bool? = true, shouldDecodeImmediately: Bool? = nil, subsampleFactor: SubsampleFactor? = nil, shouldAllowFloat: Bool? = false) {
        self.shouldCache = shouldCache
        self.shouldDecodeImmediately = shouldDecodeImmediately
        self.subsampleFactor = subsampleFactor
        self.shouldAllowFloat = shouldAllowFloat
    }
    
    public static func subsampleFactor(_ subsampleFactor: SubsampleFactor) -> Options {
        return Options(subsampleFactor: subsampleFactor)
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case shouldAllowFloat = "kCGImageSourceShouldAllowFloat"
        case shouldCache = "kCGImageSourceShouldCache"
        case shouldDecodeImmediately = "kCGImageSourceShouldCacheImmediately"
        case subsampleFactor = "kCGImageSourceSubsampleFactor"
    }
}


class OptionsThumbnail: Options {
    public var maxSize: Int? = nil
    public var shouldTransform: Bool? = nil
    public var createOption: CreateOption = .always
    
    public enum CreateOption: Codable {
        case ifAbsent
        case always
        case never
    }
    
    public init(shouldCache: Bool? = true, shouldDecodeImmediately: Bool? = nil, subsampleFactor: SubsampleFactor? = nil, shouldAllowFloat: Bool? = false, maxSize: Int? = nil,shouldTransform: Bool? = nil, createOption: CreateOption = .always ) {
        super.init(shouldCache: shouldCache, shouldDecodeImmediately: shouldDecodeImmediately, subsampleFactor: subsampleFactor, shouldAllowFloat: shouldAllowFloat)
        self.maxSize = maxSize
        self.shouldTransform = shouldTransform
        self.createOption = createOption
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.shouldTransform = try values.decodeIfPresent(Bool.self, forKey: .shouldTransform)
        self.maxSize = try values.decodeIfPresent(Int.self, forKey: .maxSize)
        let bb = try decoder.container(keyedBy: CodingKeys.Option.self)
        if bb.allKeys.contains(.always) {self.createOption = .always}
        else if bb.allKeys.contains(.ifAbsent) {self.createOption = .ifAbsent}
        else {self.createOption = .never}
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var aa = encoder.container(keyedBy: OptionsThumbnail.CodingKeys.self)
        try aa.encodeIfPresent(maxSize, forKey: .maxSize)
        try aa.encodeIfPresent(shouldTransform, forKey: .shouldTransform)
        var bb = encoder.container(keyedBy: CodingKeys.Option.self)
        if (createOption == .ifAbsent) { try bb.encode(true, forKey: .ifAbsent) }
        if (createOption == .always) { try bb.encode(true, forKey: .always) }
    }
    
    convenience init(maxSize: Int, subsampleFactor: SubsampleFactor) {
        self.init(subsampleFactor: subsampleFactor, maxSize: maxSize)
    }
    
    public static func maxSize(_ maxSize: Int) -> OptionsThumbnail {
        return OptionsThumbnail(maxSize: maxSize)
    }
    
    public static func maxSize(_ maxSize: CGSize) -> OptionsThumbnail {
        let maxSize = Int(max(maxSize.width, maxSize.height))
        return OptionsThumbnail(maxSize: maxSize)
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case maxSize = "kCGImageSourceThumbnailMaxPixelSize"
        case shouldTransform = "kCGImageSourceCreateThumbnailWithTransform"
        enum Option: String, CodingKey, CaseIterable {
            case ifAbsent = "kCGImageSourceCreateThumbnailFromImageIfAbsent"
            case always = "kCGImageSourceCreateThumbnailFromImageAlways"
        }
    }
}
 */
