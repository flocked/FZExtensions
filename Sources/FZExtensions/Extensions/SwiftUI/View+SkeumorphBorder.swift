//
//  File.swift
//  
//
//  Created by Florian Zand on 06.10.22.
//

import SwiftUI

@available(macOS 12.0, iOS 15.0, *)
internal struct SkeuomorphBorder: ViewModifier {
    private let color: Color
    private let width: CGFloat
    private let cornerRadius: CGFloat
    internal init(cornerRadius: CGFloat = 4.0, color: Color = .black, width: CGFloat = 1.0) {
        self.color = color
        self.width = width
        self.cornerRadius = cornerRadius
    }
    
    internal func body(content: Content) -> some View {
        content.cornerRadius(cornerRadius)
            .overlay{
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color.opacity(0.5), lineWidth: width)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.5), lineWidth: width)
                    .padding(EdgeInsets(top: width, leading: width, bottom: width, trailing: width))
        }
    }
}

@available(macOS 12.0, iOS 15.0, *)
internal struct SkeuomorphShapeBorder<S: Shape>: ViewModifier {
    private let color: Color
    private let width: CGFloat
    private let shape: S
    internal init(_ shape: S, color: Color = .black, width: CGFloat = 1.0) {
        self.color = color
        self.width = width
        self.shape = shape
    }
    
    internal func body(content: Content) -> some View {
        content
            .clipShape(shape)
            .overlay{
                shape.stroke(color.opacity(0.5), lineWidth: width)
                shape.stroke(.white.opacity(0.5), lineWidth: width)
                    .padding(EdgeInsets(top: width, leading: width, bottom: width, trailing: width))
        }
    }
}

@available(macOS 12.0, iOS 15.0, *)
public extension View {    
    @ViewBuilder
    func skeuomorphBorder(cornerRadius: CGFloat = 4.0, color: Color = .black, width: CGFloat = 1.0) -> some View {
        self.modifier(SkeuomorphBorder(cornerRadius: cornerRadius, color: color, width: width))
    }
    
    @ViewBuilder
    func skeuomorphBorder<S: Shape>(_ shape: S, color: Color = .black, width: CGFloat = 1.0) -> some View {
        self.modifier(SkeuomorphShapeBorder(shape, color: color, width: width))
    }
}
