//
//  ImageProperties.swift
//  ATest
//
//  Created by Florian Zand on 02.06.22.
//

import Foundation
import CoreGraphics

public struct ImageProperties: Codable {
    public var fileSize: Int?
    public var pixelWidth: CGFloat?
    public var pixelHeight: CGFloat?
    private var _orientation: Orientation?
    public var hasAlpha: Bool?
    public var colorModel: String?
    public var colorProfile: String?
    public var dpiWidth: CGFloat?
    public var dpiHeight: CGFloat?
    public var depth: Int?

    public var gif: GIF?
    public var png: PNG?
    public var jpeg: JPEG?
    public var tiff: TIFF?
    public var iptc: IPTC?
    public var heic: HEIC?
    public var exif: EXIF?

    public var pixelSize: CGSize? {
        guard var width = pixelWidth, var height = self.pixelHeight else {return nil}
        if self.orientation.needsSwap {
            swap(&width, &height)
        }
        return CGSize(width: width, height: height)
    }
    
    public var dpiSize: CGSize? {
        guard var width = dpiWidth, var height = self.dpiHeight else {return nil}
        if self.orientation.needsSwap {
            swap(&width, &height)
        }
        return CGSize(width: width, height: height)
    }
    
    public var orientation: Orientation {
        return _orientation ?? tiff?.orientation ?? iptc?.orientation ?? .up
    }
    
    public var isScreenshot: Bool {
        return exif?.isScreenshot ?? false
    }
    
    public var loopCount: Int {
             return heic?.loopCount ?? gif?.loopCount ?? png?.loopCount ?? 1
    }
        
    public var clampedDelayTime: Double? {
            return heic?.clampedDelayTime ?? gif?.clampedDelayTime ?? png?.clampedDelayTime
        }
        
    public var unclampedDelayTime: Double? {
            return heic?.unclampedDelayTime ?? gif?.unclampedDelayTime ?? png?.unclampedDelayTime
        }
    
    private static let capDurationThreshold: Double = 0.02 - Double.ulpOfOne
    public var delayTime: Double? {
        let value = self.unclampedDelayTime ?? self.clampedDelayTime
        if let value = value, value < ImageProperties.capDurationThreshold {
            return 0.1
        }
        return value
    }
                
    enum CodingKeys: String, CodingKey, CaseIterable {
        case fileSize = "FileSize"
        case pixelWidth = "PixelWidth"
        case pixelHeight = "PixelHeight"
        case _orientation = "Orientation"
        case gif = "{GIF}"
        case png = "{PNG}"
        case jpeg = "{JFIF}"
        case tiff = "{TIFF}"
        case iptc = "{IPTC}"
        case heic = "{HEICS}"
        case exif = "{Exif}"
        case dpiWidth = "DPIWidth"
        case dpiHeight = "DPIHeight"
        case hasAlpha = "HasAlpha"
        case colorProfile = "ProfileName"
        case colorModel = "ColorModel"
        case depth = "Depth"
      }
}

extension ImageProperties {
    public enum Orientation : UInt32, Codable {
        case up = 1 // 0th row at top,    0th column on left   - default orientation
        case upMirrored = 2 // 0th row at top,    0th column on right  - horizontal flip
        case down = 3 // 0th row at bottom, 0th column on right  - 180 deg rotation
        case downMirrored = 4 // 0th row at bottom, 0th column on left   - vertical flip
        case leftMirrored = 5 // 0th row on left,   0th column at top
        case right = 6 // 0th row on right,  0th column at top    - 90 deg CW
        case rightMirrored = 7 // 0th row on right,  0th column on bottom
        case left = 8 // 0th row on left,   0th column at bottom - 90 deg CCW
        
        var needsSwap: Bool {
            switch self.rawValue {
            case 5...8: return true
            default: return false }
        }
        
        var transform: CGAffineTransform {
            switch self.rawValue {
        case 2:
            return CGAffineTransform(scaleX: -1, y: 1)
        case 3:
            return CGAffineTransform(scaleX: -1, y: -1)
        case 4:
            return CGAffineTransform(scaleX: 1, y: -1)
        case 5:
            return CGAffineTransform(scaleX: -1, y: 1).rotated(by: .pi / 2)
        case 6:
            return CGAffineTransform(rotationAngle: .pi / 2)
        case 7:
            return CGAffineTransform(scaleX: -1, y: 1).rotated(by: -.pi / 2)
        case 8:
            return CGAffineTransform(rotationAngle: -.pi / 2)
        default: // 1
            return CGAffineTransform.identity
        }
    }
    }
}

extension ImageProperties {
    static var decoder: JSONDecoder {
        .init(dateDecodingStrategy: .formatted("yyyy:MM:dd HH:mm:ss"))
    }
    static var encoder: JSONEncoder {
        .init(dateEncodingStrategy: .formatted("yyyy:MM:dd HH:mm:ss"))
    }
}
