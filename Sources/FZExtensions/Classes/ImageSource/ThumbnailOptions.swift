//
//  ThumbnailImageOptions.swift
//  ATest
//
//  Created by Florian Zand on 02.06.22.
//

import Foundation

public struct ThumbnailOptions: Codable {
    public var shouldCache: Bool? = true
    public var shouldDecodeImmediately: Bool? = true
    public var subsampleFactor: ImageOptions.SubsampleFactor? = nil
    public var maxSize: Int? = nil
    public var shouldTransform: Bool? = nil
    public var shouldAllowFloat: Bool? = false
    private var createIfAbsent: Bool? = nil
    private var createAlways: Bool? = true
    
    public enum CreateBehavior: Codable {
        case ifAbsent
        case always
        case never
    }
    
    public var createBehavior: CreateBehavior {
        get {   if createAlways == true { return .always }
                else if createIfAbsent == true { return .ifAbsent }
                return .never }
        set {   self.createAlways = (newValue == .always) ? true : nil
                self.createIfAbsent = (newValue == .ifAbsent) ? true : nil }
        }
    
    public init(shouldAllowFloat: Bool? = false, shouldCache: Bool? = true, shouldDecodeImmediately: Bool? = true, shouldTransform: Bool? = nil, subsampleFactor: ImageOptions.SubsampleFactor? = nil, maxSize: Int? = nil, createBehavior: CreateBehavior = .always) {
        self.shouldAllowFloat = shouldAllowFloat
        self.shouldCache = shouldCache
        self.shouldDecodeImmediately = shouldDecodeImmediately
        self.shouldTransform = shouldTransform
        self.subsampleFactor = subsampleFactor
        self.maxSize = maxSize
        self.createAlways = true
    }

    enum CodingKeys: String, CodingKey, CaseIterable {
        case shouldAllowFloat = "kCGImageSourceShouldAllowFloat"
        case shouldCache = "kCGImageSourceShouldCache"
        case shouldDecodeImmediately = "kCGImageSourceShouldCacheImmediately"
        case subsampleFactor = "kCGImageSourceSubsampleFactor"
        case maxSize = "kCGImageSourceThumbnailMaxPixelSize"
        case shouldTransform = "kCGImageSourceCreateThumbnailWithTransform"
        case createIfAbsent = "kCGImageSourceCreateThumbnailFromImageIfAbsent"
        case createAlways = "kCGImageSourceCreateThumbnailFromImageAlways"
    }
}

extension ThumbnailOptions {
    public var dic: CFDictionary {
        var dic = [String: Any]()
        dic[CodingKeys.shouldAllowFloat.rawValue] = self.shouldAllowFloat
        dic[CodingKeys.shouldCache.rawValue] = self.shouldCache
        dic[CodingKeys.shouldDecodeImmediately.rawValue] = self.shouldDecodeImmediately
        dic[CodingKeys.subsampleFactor.rawValue] = self.subsampleFactor?.rawValue
        dic[CodingKeys.maxSize.rawValue] = self.maxSize
        dic[CodingKeys.shouldTransform.rawValue] = self.shouldTransform
        dic[CodingKeys.createAlways.rawValue] = self.createAlways
        dic[CodingKeys.createIfAbsent.rawValue] = self.createIfAbsent
        return dic as CFDictionary
    }
    
    public init(subsampleFactor: ImageOptions.SubsampleFactor?, maxSize: CGSize?) {
        let maxSize = (maxSize != nil) ? Int(max(maxSize!.width, maxSize!.height)) : nil
        self.init(shouldAllowFloat: nil, shouldCache: true, shouldDecodeImmediately: true, shouldTransform: nil, subsampleFactor: subsampleFactor, maxSize: maxSize, createBehavior: .always)
    }
    
    public static func maxSize(_ maxSize: CGSize) -> ThumbnailOptions {
        return self.init(subsampleFactor: nil, maxSize: maxSize)
    }
    
    public static func maxSize(_ maxSize: Int) -> ThumbnailOptions {
        return self.init(subsampleFactor: nil, maxSize: maxSize)
    }
        
    public static func subsampleFactor(_ subsampleFactor: ImageOptions.SubsampleFactor) -> ThumbnailOptions {
        return self.init(subsampleFactor: subsampleFactor, maxSize: nil)
    }
}





        /*
public var rawValue: CFDictionary {
 //  let oo = ImageOptions(shouldAllowFloat: self.shouldAllowFloat, shouldCache: self.shouldCache, shouldDecodeImmediately: self.shouldDecodeImmediately, subsamplingLevel: self.subsampleFactor).rawValue as! [CFString: Any]
    var options: [CFString: Any] = [:]
    options[kCGImageSourceShouldAllowFloat] = self.shouldAllowFloat
    options[kCGImageSourceShouldCache] = self.shouldCache
    options[kCGImageSourceShouldCacheImmediately] = self.shouldDecodeImmediately
    options[kCGImageSourceSubsampleFactor] = self.subsampleFactor
    options[kCGImageSourceCreateThumbnailWithTransform] = self.shouldTransform
    options[kCGImageSourceThumbnailMaxPixelSize] = maxPixelSize
    if let size = maxPixelSize {
        options[kCGImageSourceThumbnailMaxPixelSize] = Int(max(size.width, size.height))
    }

    if let createThumbnailBehavior = self.createBehavior {
        switch createThumbnailBehavior {
        case .ifAbsent:
            options[kCGImageSourceCreateThumbnailFromImageIfAbsent] = true
        case .always:
            options[kCGImageSourceCreateThumbnailFromImageAlways] = true
        }
    }
    return options as CFDictionary
} */



/*
 public struct ThumbnailImageOptions: Codable {
 public var shouldAllowFloat: Bool?
 public var shouldCache: Bool?
 public var shouldDecodeImmediately: Bool?
 public var createThumbnailWithTransform: Bool?
 public var createThumbnailBehavior: CreateThumbnailBehavior?
 public var subsamplingLevel: SubsamplingLevel?
 public var thumbnailMaxPixelSize: CGSize?
 
 public init(shouldAllowFloat: Bool? = nil, shouldCache: Bool? = true, shouldDecodeImmediately: Bool? = nil, createThumbnailWithTransform: Bool? = nil, createThumbnailBehavior: CreateThumbnailBehavior? = nil, subsamplingLevel: SubsamplingLevel? = nil, thumbnailMaxPixelSize: CGSize? = nil) {
     self.shouldAllowFloat = shouldAllowFloat
     self.shouldCache = shouldCache
     self.shouldDecodeImmediately = shouldDecodeImmediately
     self.createThumbnailWithTransform = createThumbnailWithTransform
     self.createThumbnailBehavior = createThumbnailBehavior
     self.subsamplingLevel = subsamplingLevel
     self.thumbnailMaxPixelSize = thumbnailMaxPixelSize
 }
     
 static func async(subsamplingLevel: SubsamplingLevel? = nil, maxSize: CGSize? = nil) -> ThumbnailImageOptions {
     var options = ThumbnailImageOptions(shouldCache: true, shouldDecodeImmediately: true, createThumbnailBehavior: .always)
     options.subsamplingLevel = subsamplingLevel
     options.thumbnailMaxPixelSize = maxSize
     return options
 }
 
 public var rawValue: CFDictionary {
     var options: [CFString: Any] = [:]
     options[kCGImageSourceShouldAllowFloat] = self.shouldAllowFloat
     options[kCGImageSourceShouldCache] = self.shouldCache
     options[kCGImageSourceShouldCacheImmediately] = self.shouldDecodeImmediately
     options[kCGImageSourceCreateThumbnailWithTransform] = self.createThumbnailWithTransform
     options[kCGImageSourceSubsampleFactor] = self.subsamplingLevel
     options[kCGImageSourceThumbnailMaxPixelSize] = thumbnailMaxPixelSize
     if let maxSize = thumbnailMaxPixelSize {
         options[kCGImageSourceThumbnailMaxPixelSize] = Int(max(maxSize.width, maxSize.height))
     }

     if let createThumbnailBehavior = self.createThumbnailBehavior {
         switch createThumbnailBehavior {
         case .ifAbsent:
             options[kCGImageSourceCreateThumbnailFromImageIfAbsent] = true
         case .always:
             options[kCGImageSourceCreateThumbnailFromImageAlways] = true
         }
     }
     return options as CFDictionary
 }
 
 public enum CreateThumbnailBehavior: Codable {
     case ifAbsent
     case always
 }
 
 public enum SubsamplingLevel: Int, Codable {
     case level2 = 2
     case level4 = 4
     case level8 = 8
 }
}
*/
