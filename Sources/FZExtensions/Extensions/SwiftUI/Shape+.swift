//
//  File.swift
//  
//
//  Created by Florian Zand on 02.10.22.
//

import Foundation
import SwiftUI

public struct AnyShape: InsettableShape {
    private var base: (CGRect) -> SwiftUI.Path
    private var insetAmount: CGFloat = 0
    
    public init<S: Shape>(_ shape: S) {
        base = shape.path(in:)
    }
    
    public func path(in rect: CGRect) -> SwiftUI.Path {
        base(rect)
    }
    
    public func inset(by amount: CGFloat) -> some InsettableShape {
        var shape = self
        shape.insetAmount = amount
        return shape
    }
}

public extension Shape {
    func asAnyShape() -> AnyShape {
        return AnyShape(self)
    }
}
