//
//  NSImage+GIF.swift
//  FZExtensions
//
//  Created by Florian Zand on 05.06.22.
//

#if os(macOS)

import Foundation
import AppKit
import UniformTypeIdentifiers

extension NSImage {
    class func gifData(from images: [NSImage], duration: Float) -> Data? {
        let frameDuration = duration / Float(images.count)
        return gifData(from: images, frameDuration: frameDuration)
    }
    
   private class func gifData(from images: [NSImage], frameDuration: Float) -> Data? {
        let data = NSMutableData()
        let frameDuration = frameDuration * 2
        guard let dest = CGImageDestinationCreateWithData(data as CFMutableData,kUTTypePNG, images.count, nil) else { return nil }
        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]
        CGImageDestinationSetProperties(dest, fileProperties as CFDictionary)
        let gifProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: frameDuration]]
        for image in images {
            if let cgImage = image.cgImage {
                CGImageDestinationAddImage(dest, cgImage, gifProperties as CFDictionary?)
            }
        }
        CGImageDestinationFinalize(dest)
        return data as Data
    }
    
    class func animatedImage(with images: [NSImage], duration: Float) -> NSImage? {
        if let gifData = NSImage.gifData(from: images, duration: duration) {
            return NSImage(data: gifData)
        }
        return nil
    }
}

extension NSImage {
    var isGif: Bool {
        return (framesCount > 1)
    }
    
    var framesCount: Int {
        guard let bitmapRep = self.representations[0] as? NSBitmapImageRep,
              let frameCount = (bitmapRep.value(forProperty: .frameCount) as? NSNumber)?.intValue else {
            return 1
        }
        return frameCount
    }
    
    func gifFrames() -> [ImageFrame]? {
        guard let bitmapRep = self.representations[0] as? NSBitmapImageRep,
              let frameCount = (bitmapRep.value(forProperty: .frameCount) as? NSNumber)?.intValue, frameCount > 1 else { return nil }
        
        var frames = [ImageFrame]()
          for n in 0 ..< frameCount {
              bitmapRep.setProperty(.currentFrame, withValue: NSNumber(value: n))
              if let data = bitmapRep.representation(using: .gif, properties: [:]),
                 let image = NSImage(data: data) {
                  var frame = ImageFrame(image, ImageSource.defaultFrameDuration)
                  if let frameDuration = (bitmapRep.value(forProperty: .currentFrameDuration) as? NSNumber)?.doubleValue {
                      frame.duration = frameDuration
                  }
                  frames.append(frame)
              }
          }
        return frames
    }
}

#endif
