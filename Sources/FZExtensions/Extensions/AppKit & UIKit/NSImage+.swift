//
//  NSImage+.swift
//  FZCollection
//
//  Created by Florian Zand on 25.04.22.
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
import UniformTypeIdentifiers

public extension NSUIImage {
     convenience init(color: NSUIColor) {
        let size = CGSize(width: 1, height: 1)

        #if canImport(UIKit)
        let image = UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(context.format.bounds)
        }.resizableImage(withCapInsets: .zero)
        self.init(cgImage: image.cgImage!)
        #else
        self.init(size: size, flipped: false) { rect in
            color.setFill()
            rect.fill()
            return true
        }
        resizingMode = .stretch
        capInsets = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        #endif
    }
}

public extension CGImage {
#if os(macOS)
    var nsImage: NSImage {
        return NSImage(cgImage: self)
    }
#elseif canImport(UIKit)
    var uiImage: UIImage {
        return UIImage(cgImage: self)
    }
#endif
    
    var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
}

#if os(macOS)
public extension NSImage {
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: .zero)
    }
    
    var cgImage: CGImage? {
        guard let imageData = self.tiffRepresentation else { return nil }
            guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
            return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
        
   //     return self.cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    var cgImageSource: CGImageSource? {
        if let data = self.tiffRepresentation {
            return CGImageSourceCreateWithData(data as CFData, nil)
        }
        return nil
    }
}

public extension NSImage {
    func tinted(_ tintColor: NSColor) -> NSImage {
        guard self.isTemplate else { return self }

        let image = self.copy() as! NSImage
        image.lockFocus()

        tintColor.set()
        NSRect(origin: .zero, size: image.size).fill(using: .sourceAtop)

        image.unlockFocus()
        image.isTemplate = false

        return image
      }
    
    func roundedCorners(radius: CGFloat) -> NSImage {
        let rect = NSRect(origin: NSPoint.zero, size: size)
        if
            let cgImage = self.cgImage,
            let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) {
            context.beginPath()
            context.addPath(CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil))
            context.closePath()
            context.clip()
            context.draw(cgImage, in: rect)

            if let composedImage = context.makeImage() {
                return NSImage(cgImage: composedImage, size: size)
            }
        }
        return self
    }

      func rounded() -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()

        let frame = NSRect(origin: .zero, size: size)
        NSBezierPath(ovalIn: frame).addClip()
        draw(at: .zero, from: frame, operation: .sourceOver, fraction: 1)

        image.unlockFocus()
        return image
      }

      static func maskImage(cornerRadius: CGFloat) -> NSImage {
        let image = NSImage(size: NSSize(width: cornerRadius * 2, height: cornerRadius * 2), flipped: false) { rectangle in
          let bezierPath = NSBezierPath(roundedRect: rectangle, xRadius: cornerRadius, yRadius: cornerRadius)
          NSColor.black.setFill()
          bezierPath.fill()
          return true
        }
        image.capInsets = NSEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius)
        return image
      }

      func rotated(degree: Int) -> NSImage {
        var degree = ((degree % 360) + 360) % 360
        guard degree % 90 == 0 && degree != 0 else { return self }
        // mpv's rotation is clockwise, NSAffineTransform's rotation is counterclockwise
        degree = 360 - degree
        let newSize = (degree == 180 ? self.size : NSMakeSize(self.size.height, self.size.width))
        let rotation = NSAffineTransform.init()
        rotation.rotate(byDegrees: CGFloat(degree))
        rotation.append(.init(translationByX: newSize.width / 2, byY: newSize.height / 2))

        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        rotation.concat()
        let rect = NSMakeRect(0, 0, self.size.width, self.size.height)
        let corner = NSMakePoint(-self.size.width / 2, -self.size.height / 2)
        self.draw(at: corner, from: rect, operation: .copy, fraction: 1)
        newImage.unlockFocus()
        return newImage
      }

}

extension NSBitmapImageRep {
    var jpegData: Data? { representation(using: .jpeg, properties: [:]) }
    var pngData: Data? { representation(using: .png, properties: [:]) }
    var tiffData: Data? { representation(using: .tiff, properties: [:]) }
}

public extension NSImage {
    var bitmapImageRep: NSBitmapImageRep? {
        if let cgImage = self.cgImage {
            let imageRep = NSBitmapImageRep(cgImage: cgImage)
            imageRep.size = self.size
            return imageRep
        }
        return nil
    }
    
    var tiffData: Data? { tiffRepresentation }
    var pngData: Data? { bitmapImageRep?.pngData }
    var jpegData: Data? { bitmapImageRep?.jpegData }
}

public extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}

public extension NSImage {
     func scaled(toFit size: CGSize) -> NSImage {
        let size = self.size.scaled(toFit: size)
        return self.resized(to: size)
    }
     func scaled(toFill size: CGSize) -> NSImage {
        let size = self.size.scaled(toFill: size)
        return self.resized(to: size)
    }
    
     func resized(to size: CGSize) -> NSImage {
        let scaledImage = NSImage(size: size)
        scaledImage.cacheMode = .never
        scaledImage.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .default
        self.draw(in: NSRect(x: 0, y: 0, width: size.width, height: size.height), from: .zero, operation: .copy, fraction: 1.0)
        scaledImage.unlockFocus()
        return scaledImage
    }
}
#endif
