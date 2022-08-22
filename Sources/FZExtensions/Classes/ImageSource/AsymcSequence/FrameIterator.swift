//
//  CGsd.swift
//  ATest
//
//  Created by Florian Zand on 03.06.22.
//

import Foundation
import ImageIO

public struct ImageFrameIterator: AsyncIteratorProtocol {
    public let loop: Bool
    public let frameCount: Int
    public private(set) var currentFrame: Int
    public let source: ImageSource
    public let options: CFDictionary?
    public let type: FrameType
    public enum FrameType {
        case image
        case thumbnail
    }

    public init(source: ImageSource, options: ImageOptions?, loop: Bool = false) {
        self.init(source: source, type: .image, options: options?.toCFDictionary(), loop: loop)
    }
    
    public init(source: ImageSource, options: ThumbnailOptions?, loop: Bool = false) {
        self.init(source: source, type: .thumbnail, options: options?.toCFDictionary(), loop: loop)
    }
    
    public init(source: ImageSource, type: FrameType, options: CFDictionary?, loop: Bool = false) {
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

    public mutating func next() async -> CGImageFrame? {
        if currentFrame >= frameCount {
            if loop { currentFrame = 0 }
            else { return nil }
        }
        
        return await withCheckedContinuation { continuation in
            let duration = self.source.properties(at: self.currentFrame)?.delayTime ?? ImageSource.defaultFrameDuration
             self.createImage(self.source.cgImageSource, currentFrame, options, completionHandler: {
                 image in
                 if let image = image {
                     continuation.resume(returning: CGImageFrame(image, duration))
                 } else {
                     continuation.resume(returning: nil)
                 }
             })
            self.currentFrame = self.currentFrame + 1
         }
    }
}
