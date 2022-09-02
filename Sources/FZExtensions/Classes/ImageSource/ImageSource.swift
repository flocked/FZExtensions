//
//  ImageSource.swift
//  ATest
//
//  Created by Florian Zand on 02.06.22.
//

import Foundation
import ImageIO
import UniformTypeIdentifiers
import simd

public class ImageSource {
    public let cgImageSource: CGImageSource
    
    public var typeIdentifier: String? {
        return CGImageSourceGetType(self.cgImageSource) as String?
    }
    
    
    @available(macOS 11.0, iOS 14.0, *)
    public var utType: UTType? {
        guard let typeIdentifier = typeIdentifier else { return nil }
        return UTType(typeIdentifier)
    }
    
    public var count: Int {
        return CGImageSourceGetCount(self.cgImageSource)
    }
    
    public var status: CGImageSourceStatus {
        CGImageSourceGetStatus(cgImageSource)
    }
    
    public func status(at index: Int) -> CGImageSourceStatus {
        return CGImageSourceGetStatusAtIndex(cgImageSource, index)
    }
    
    public var primaryImageIndex: Int {
        return CGImageSourceGetPrimaryImageIndex(cgImageSource)
    }
    
    public func properties() -> ImageProperties? {
        let rawValue = CGImageSourceCopyProperties(cgImageSource, nil) as? [String: Any] ?? [:]
        return rawValue.toModel(ImageProperties.self, decoder: ImageProperties.decoder)
    }
    
    public func properties(at index: Int) -> ImageProperties? {
        let rawValue = CGImageSourceCopyPropertiesAtIndex(cgImageSource, index, nil) as? [String: Any] ?? [:]
        return rawValue.toModel(ImageProperties.self, decoder: ImageProperties.decoder)
    }
    
    public func getImage(at index: Int = 0, options: ImageOptions? = .init()) -> CGImage? {
        return CGImageSourceCreateImageAtIndex(cgImageSource, index, options?.dic)
    }
    
    public func imageAsync(at index: Int = 0, options: ImageOptions? = .init()) async throws -> CGImage? {
        guard let image = getImage(at: index, options: options) else {
            throw Error.failedImageCreate
        }
        return image
    }
    
    public func image(at index: Int = 0, options: ImageOptions? = .init(), completionHandler: @escaping (CGImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let image = CGImageSourceCreateImageAtIndex(self.cgImageSource, index, options?.dic)
            completionHandler(image)
        }
    }
    
    public func getThumbnail(at index: Int = 0, options: ThumbnailOptions? = .init()) -> CGImage? {
        return CGImageSourceCreateThumbnailAtIndex(cgImageSource, index, options?.toCFDictionary())
    }
    
    public func thumbnail(at index: Int = 0, options: ThumbnailOptions? = .init()) async throws -> CGImage {
        guard let thumbnail = getThumbnail(at: index, options: options) else {
            throw Error.failedThumbnailCreate
        }
        return thumbnail
    }
    
    public func thumbnail(at index: Int = 0, options: ThumbnailOptions? = .init(), completionHandler: @escaping (CGImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let image = CGImageSourceCreateThumbnailAtIndex(self.cgImageSource, index, options?.toCFDictionary())
            completionHandler(image)
        }
    }
    
    public func images(options: ImageOptions? = .init()) -> ImageSequence {
        return ImageSequence(self, options: options)
    }
    
    public func thumbnails(options: ThumbnailOptions? = .init()) -> ThumbnailSequence {
        return ThumbnailSequence(self, options: options)
    }
    
    public func imageFrames(options: ImageOptions? = .init()) -> ImageFrames {
        return ImageFrames(self, options: options)
    }
    
    public func thumbnailFrames(options: ThumbnailOptions? = .init()) -> ThumbnailFrames {
        return ThumbnailFrames(self, options: options)
    }
    
    public func getImageFrames(options: ImageOptions? = .init()) -> [CGImageFrame] {
        var frames =  [CGImageFrame]()
        for i in 0..<self.count {
            if let image = getImage(at: i, options: options) {
                let duration = properties(at: i)?.delayTime ?? ImageSource.defaultFrameDuration
                let frame = CGImageFrame(image, duration)
                frames.append(frame)
            }
        }
        return frames
    }
    
    public func getThumbnailFrames(options: ThumbnailOptions? = .init()) -> [CGImageFrame] {
        var frames =  [CGImageFrame]()
        for i in 0..<self.count {
            if let image = getThumbnail(at: i, options: options) {
                let duration = properties(at: i)?.delayTime ?? ImageSource.defaultFrameDuration
                let frame = CGImageFrame(image, duration)
                frames.append(frame)
            }
        }
        return frames
    }
    
    public init(_ cgImageSource: CGImageSource) {
        self.cgImageSource = cgImageSource
    }
    
    public convenience init?(url: URL) {
        guard let cgImageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        self.init(cgImageSource)
    }
    
    public convenience init?(path: String) {
        self.init(url: URL(fileURLWithPath: path))
    }
    
    public convenience init?(data: Data) {
        guard let cgImageSource = CGImageSourceCreateWithData(data as CFData, nil) else {return nil}
        self.init(cgImageSource)
    }
}
extension ImageSource: CustomStringConvertible {
    public var description: String {
        return "ImageSource[\(ObjectIdentifier(self))"
    }
}

extension ImageSource: Equatable {
    public static func == (lhs: ImageSource, rhs: ImageSource) -> Bool {
        return lhs.cgImageSource == rhs.cgImageSource
    }
}

extension ImageSource {
    public var isAnimatable: Bool {
        let utIdentifier = self.typeIdentifier
        let animatableUTTs: [CFString] = [kUTTypeGIF, kUTTypePNG, "public.heif-standard" as CFString]
        if self.count > 1, let utIdentifier = utIdentifier, animatableUTTs.contains(utIdentifier as CFString) {
            return true
        }
        return false
    }
    
    public var pixelSize: CGSize? {
        return properties(at: 0)?.pixelSize
    }
    
    private static let defaultFrameRate: Double = 15.0
    public static let defaultFrameDuration: Double = 1 / defaultFrameRate
    public var animationDuration: Double {
        let totalDuration = (0..<count).reduce(0) { $0 + (self.properties(at: $1)?.delayTime ?? ImageSource.defaultFrameDuration) }
        return totalDuration
    }
}

extension ImageSource {
    enum Error: Swift.Error {
        case failedThumbnailCreate
        case failedImageCreate
    }
}

#if os(macOS)
import AppKit
extension ImageSource {
    public convenience init?(image: NSImage) {        guard let data = image.tiffRepresentation else { return nil }
        self.init(data: data)
    }
}
#endif

#if canImport(UIKit)
import UIKit
extension ImageSource {
    public convenience init?(image: UIImage) {        guard let data = image.pngData() else { return nil }
        self.init(data: data)
    }
}
#endif
