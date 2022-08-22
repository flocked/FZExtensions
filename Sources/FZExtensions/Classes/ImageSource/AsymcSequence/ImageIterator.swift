//
//  CGsd.swift
//  ATest
//
//  Created by Florian Zand on 03.06.22.
//

import Foundation
import ImageIO

public struct ImageIterator: AsyncIteratorProtocol {
    public let loop: Bool
    public let frameCount: Int
    public private(set) var currentFrame: Int
    public let source: ImageSource
    public let options: CFDictionary?
    public let type: ImageType
    public enum ImageType {
        case image
        case thumbnail
    }

    public init(source: ImageSource, options: ImageOptions?, loop: Bool = false) {
        self.init(source: source, type: .image, options: options?.toCFDictionary(), loop: loop)
    }
    
    public init(source: ImageSource, options: ThumbnailOptions?, loop: Bool = false) {
        self.init(source: source, type: .thumbnail, options: options?.toCFDictionary(), loop: loop)
    }
    
    public init(source: ImageSource, type: ImageType, options: CFDictionary?, loop: Bool = false) {
        self.source = source
        self.frameCount = source.count
        self.currentFrame = 0
        self.loop = loop
        self.type = type
        self.options = options
    }
    
    func createImage(_ isrc: CGImageSource, _ index: Int, _ options: CFDictionary?) -> CGImage? {
        if (type == .image) { return CGImageSourceCreateImageAtIndex(isrc, index, options) }
        else { return CGImageSourceCreateThumbnailAtIndex(isrc, index, options) }
    }
    
    func createImage(_ isrc: CGImageSource, _ index: Int, _ options: CFDictionary?, completionHandler: @escaping (CGImage?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
           let image =  self.createImage(isrc, index, options)
            completionHandler(image)
        }
    }

    public mutating func next() async -> CGImage? {
        if currentFrame >= frameCount {
            if loop { currentFrame = 0 }
            else { return nil }
        }
       return await withCheckedContinuation { continuation in
            self.createImage(self.source.cgImageSource, currentFrame, options, completionHandler: {
                image in
                continuation.resume(returning: image)
            })
           self.currentFrame = self.currentFrame + 1
        }
    }
}
