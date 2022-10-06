//
//  File.swift
//  
//
//  Created by Florian Zand on 02.10.22.
//

import Foundation
import SwiftUI

public struct RectCorner: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static let topLeft = RectCorner(rawValue: 1 << 0)
    public static let topRight = RectCorner(rawValue: 1 << 1)
    public static let bottomLeft = RectCorner(rawValue: 1 << 2)
    public static let bottomRight = RectCorner(rawValue: 1 << 3)
    public static let all: RectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}

public struct RoundedCorner: Shape {
    public let radius: CGFloat
    public let corners: RectCorner

    public init(radius: CGFloat, corners: RectCorner) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> SwiftUI.Path {

        let topLeftRadius: CGFloat = corners.contains(.topLeft) ? radius : 0
        let bottomLeftRadius: CGFloat = corners.contains(.bottomLeft) ? radius : 0
        let bottomRightRadius: CGFloat = corners.contains(.bottomRight) ? radius : 0
        let topRightRadius: CGFloat = corners.contains(.topRight) ? radius : 0

        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: topLeftRadius))
        path.addLine(to: CGPoint(x: 0, y: rect.height - bottomLeftRadius))
        path.addArc(center: CGPoint(x: bottomLeftRadius, y: rect.height - bottomLeftRadius),
                    radius: bottomLeftRadius,
                    startAngle: CGFloat.pi,
                    endAngle: (CGFloat.pi / 2),
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.width - bottomRightRadius, y: rect.height))
        path.addArc(center: CGPoint(x: rect.width - bottomRightRadius, y: rect.height - bottomRightRadius),
                    radius: bottomRightRadius,
                    startAngle: (CGFloat.pi / 2),
                    endAngle: 0,
                    clockwise: true)
        path.addLine(to: CGPoint(x: rect.width, y: topRightRadius))
        path.addArc(center: CGPoint(x: rect.width - topRightRadius, y: topRightRadius),
                    radius: topRightRadius,
                    startAngle: 0,
                    endAngle: (CGFloat.pi / 2) * 3,
                    clockwise: true)
        path.addLine(to: CGPoint(x: topLeftRadius, y: 0))
        path.addArc(center: CGPoint(x: topLeftRadius, y: topLeftRadius),
                    radius: topLeftRadius,
                    startAngle: (CGFloat.pi / 2) * 3,
                    endAngle: CGFloat.pi,
                    clockwise: true)
        path.closeSubpath()
        return SwiftUI.Path(path)
    }
}
