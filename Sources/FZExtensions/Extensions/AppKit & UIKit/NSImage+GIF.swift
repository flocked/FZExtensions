//
//  NSImage+GIF.swift
//  FZExtensions
//
//  Created by Florian Zand on 05.06.22.
//


#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
import MobileCoreServices
#endif


public extension NSUIImage {
    class func gifData(from images: [NSUIImage], duration: Float) -> Data? {
        let frameDuration = duration / Float(images.count)
        return gifData(from: images, frameDuration: frameDuration)
    }
    
    private class func gifData(from images: [NSUIImage], frameDuration: Float) -> Data? {
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
    
    class func animatedImage(with images: [NSUIImage], duration: Float) -> NSUIImage? {
        if let gifData = NSUIImage.gifData(from: images, duration: duration) {
            return NSUIImage(data: gifData)
        }
        return nil
    }
    #if os(macOS)
    func frames() -> [ImageFrame]? {
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
    #else
    func frames() async -> [ImageFrame] {
        var frames = [ImageFrame]()
        if let imageSource = ImageSource(image: self) {
            let count = imageSource.count
            for index in 0..<count {
                if let cgImage = imageSource.getImage(at: index, options: nil) {
                    let frame = ImageFrame(NSUIImage(cgImage: cgImage),  imageSource.properties(at: index)?.delayTime ?? ImageSource.defaultFrameDuration)
                    frames.append(frame)
                }
            }
        }
        return frames
    }
    #endif
    
    var isAnimatable: Bool {
        return (framesCount > 1)
    }
    
    var framesCount: Int {
        guard let imageSource = ImageSource(image: self) else { return 1 }
        return imageSource.count
    }
}
