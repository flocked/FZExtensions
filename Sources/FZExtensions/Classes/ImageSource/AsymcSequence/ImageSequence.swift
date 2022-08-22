//
//  FrameSequence.swift
//  ATest
//
//  Created by Florian Zand on 03.06.22.
//

import Foundation
import ImageIO
import Combine

public struct ThumbnailSequence: AsyncSequence {
    public typealias Element = CGImage
    public let source: ImageSource
    public let options: CFDictionary?
    public let loop: Bool
    public init(_ source: ImageSource, options: ThumbnailOptions? = .init(), loop: Bool = false) {
        self.source = source
        self.options = options?.toCFDictionary()
        self.loop = loop
    }
    
    public func makeAsyncIterator() -> ImageIterator {
        ImageIterator(source: source, type: .thumbnail, options: options, loop: loop)
    }
}

public struct ImageSequence: AsyncSequence {
    public typealias Element = CGImage
    public let source: ImageSource
    public let options: CFDictionary?
    public let loop: Bool
    
    public init(_ source: ImageSource, options: ImageOptions? = .init(), loop: Bool = false) {
        self.source = source
        self.options = options?.toCFDictionary()
        self.loop = loop
    }
    
    public func makeAsyncIterator() -> ImageIterator {
        ImageIterator(source: source, type: .image, options: options, loop: loop)
    }
}
