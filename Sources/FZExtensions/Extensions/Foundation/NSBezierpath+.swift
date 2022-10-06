//
//  NSBezierpath+.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//

#if os(macOS)
import AppKit

public extension NSBezierPath {
    convenience init(
        roundedRect rect: CGRect,
        cornerRadius: CGFloat
    ) {
        self.init(roundedRect: rect, xRadius: cornerRadius/2.0, yRadius: cornerRadius/2.0)
    }
    
    convenience init(rect: CGRect, cornerRadius: CGFloat, roundedCorners: CACornerMask = .all) {
        if (roundedCorners == .all || cornerRadius == 0.0) {
            let radius = cornerRadius / 2.0
            self.init(roundedRect: rect, xRadius: radius, yRadius: radius)
        } else {
        self.init()
                
        let maxX: CGFloat = rect.size.width
        let minX: CGFloat = 0
        let maxY: CGFloat = rect.size.height
        let minY: CGFloat =  0

        let bottomRightCorner = CGPoint(x: maxX, y: minY)

        move(to: bottomRightCorner)

        if roundedCorners.contains(.bottomRight) {
            line(to: CGPoint(x: maxX - cornerRadius, y: minY))
            curve(to: CGPoint(x: maxX, y: minY + cornerRadius), controlPoint1: bottomRightCorner, controlPoint2: bottomRightCorner)
        } else {
            line(to: bottomRightCorner)
        }

        let topRightCorner = CGPoint(x: maxX, y: maxY)

        if roundedCorners.contains(.topRight) {
            line(to: CGPoint(x: maxX, y: maxY - cornerRadius))
            curve(to: CGPoint(x: maxX - cornerRadius, y: maxY), controlPoint1: topRightCorner, controlPoint2: topRightCorner)
        } else {
            line(to: topRightCorner)
        }

        let topLeftCorner = CGPoint(x: minX, y: maxY)

        if roundedCorners.contains(.topLeft) {
            line(to: CGPoint(x: minX + cornerRadius, y: maxY))
            curve(to: CGPoint(x: minX, y: maxY - cornerRadius), controlPoint1: topLeftCorner, controlPoint2: topLeftCorner)
        } else {
            line(to: topLeftCorner)
        }

        let bottomLeftCorner = CGPoint(x: minX, y: minY)

        if roundedCorners.contains(.bottomLeft) {
            line(to: CGPoint(x: minX, y: minY + cornerRadius))
            curve(to: CGPoint(x: minX + cornerRadius, y: minY), controlPoint1: bottomLeftCorner, controlPoint2: bottomLeftCorner)
        } else {
            line(to: bottomLeftCorner)
        }
        }
    }
}

public extension NSBezierPath {
    var cgPath: CGPath {
        return self.transformToCGPath()
    }

    private func transformToCGPath() -> CGPath {

        // Create path
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        let numElements = self.elementCount

        if numElements > 0 {

            var didClosePath = true

            for index in 0..<numElements {

                let pathType = self.element(at: index, associatedPoints: points)

                switch pathType {
                case .moveTo:
                    path.move(to: CGPoint(x: points[0].x, y: points[0].y))
                case .lineTo:
                    path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
                    didClosePath = false
                case .curveTo:
                    path.addCurve(to: CGPoint(x: points[0].x, y: points[0].y),
                                  control1: CGPoint(x: points[1].x, y: points[1].y),
                                  control2: CGPoint(x: points[2].x, y: points[2].y))
                    didClosePath = false
                case .closePath:
                    path.closeSubpath()
                    didClosePath = true
                default:
                    break
                }
            }

            if !didClosePath { path.closeSubpath() }
        }

        points.deallocate()
        return path
    }
}

public extension NSBezierPath {
   static func contactShadow(rect: CGRect, shadowSize: CGFloat = 20, shadowDistance: CGFloat = 0) -> NSBezierPath {
        let contactRect = CGRect(x: -shadowSize, y: (rect.height - (shadowSize * 0.4)) + shadowDistance, width: rect.width + shadowSize * 2, height: shadowSize)
        return NSBezierPath(ovalIn: contactRect)
    }
    
    static func depthShadow(rect: CGRect, shadowWidth: CGFloat = 1.2, shadowHeight: CGFloat = 0.5, shadowRadius: CGFloat = 5, shadowOffsetX: CGFloat = 0) -> NSBezierPath{
        let shadowPath = NSBezierPath()
        shadowPath.move(to: CGPoint(x: shadowRadius / 2, y: rect.height - shadowRadius / 2))
        shadowPath.line(to: CGPoint(x: rect.width, y: rect.height - shadowRadius / 2))
        shadowPath.line(to: CGPoint(x: rect.width * shadowWidth + shadowOffsetX, y: rect.height + (rect.height * shadowHeight)))
        shadowPath.line(to: CGPoint(x: rect.width * -(shadowWidth - 1) + shadowOffsetX, y: rect.height + (rect.height * shadowHeight)))
        return shadowPath
    }
    
    static func flatShadow(rect: CGRect, shadowOffsetX: CGFloat = 2000) -> NSBezierPath {
        // how far the bottom of the shadow should be offset
        let shadowPath = NSBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: rect.height))
        shadowPath.line(to: CGPoint(x: rect.width, y: rect.height))

        // make the bottom of the shadow finish a long way away, and pushed by our X offset
        shadowPath.line(to: CGPoint(x: rect.width + shadowOffsetX, y: 2000))
        shadowPath.line(to: CGPoint(x: shadowOffsetX, y: 2000))
        return shadowPath
    }
    
    static  func flatShadowBehind(rect: CGRect, shadowOffsetX: CGFloat = 2000) -> NSBezierPath {
        // how far the bottom of the shadow should be offset
        let shadowPath = NSBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: rect.height))
        shadowPath.line(to: CGPoint(x: rect.width, y: 0))
        shadowPath.line(to: CGPoint(x: rect.width + shadowOffsetX, y: 2000))
        shadowPath.line(to: CGPoint(x: shadowOffsetX, y: 2000))
        return shadowPath
    }
}

#endif

#if canImport(UIKit)
import UIKit
public extension UIBezierPath {
    convenience init(rect: CGRect, cornerRadius: CGFloat, roundedCorners: CACornerMask = .all) {
        self.init(roundedRect: self.rect,
                  byRoundingCorners: roundedCorners,
                  cornerRadii: CGSize(width: cornerRadius/2.0, height: cornerRadius/2.0))
    }
}
#endif
