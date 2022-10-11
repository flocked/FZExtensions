//
//  File.swift
//  
//
//  Created by Florian Zand on 24.09.22.
//

import Foundation
import SwiftUI

public extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

public extension View {
    @ViewBuilder
    func border<S: ShapeStyle>(_ content: S, width: CGFloat = 1.0, cornerRadius: CGFloat) -> some View {
        self.cornerRadius(cornerRadius)
            .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(content, lineWidth: width)
        )
    }
    
    @ViewBuilder
    func border<C: ShapeStyle, S: Shape>(_ content: C, width: CGFloat = 1.0, shape: S) -> some View {
        self.clipShape(shape)
            .overlay(
                shape
                .stroke(content, lineWidth: width)
        )
    }
    
    @available(macOS 11.0, iOS 13.0, *)
    @ViewBuilder
    func imageScaleOptional(_ scale: Image.Scale?) -> some View {
        if let scale = scale {
            self.imageScale(scale)
        } else {
            self
        }
    }
    
    @available(macOS 12.0, iOS 15.0, *)
    @ViewBuilder
    func foregroundStyleOptional(_ primary: Color?, _ secondary: Color? , _ tertiary: Color?) -> some View {
        if let primary = primary {
            if let secondary = secondary {
                if let tertiary = tertiary {
                    self.foregroundStyle(primary, secondary, tertiary)
                } else {
                    self.foregroundStyle(primary, secondary)
                }
            } else {
                self.foregroundStyle(primary)
            }
        } else {
            self
        }
    }
    
    func asAnyView() -> AnyView {
        return AnyView(self)
    }
}

