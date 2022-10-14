//
//  IrregularGradient+Modifiers.swift
//  
//
//  Created by Julian Schiavo on 5/4/2021.
//  Updated by Florian Zand on 14/09/2022

import SwiftUI

extension View {
    /// Replace view's contents with a gradient.
    ///
    /// - Parameters:
    ///   - colors: The colors of the blobs in the gradient.
    ///   - background: The background view of the gradient.
    ///   - speed: The speed at which the blobs move, if they're moving.
    ///   - animate: Whether or not the blobs should move.
    public func irregularGradient<Background: View>(colors: [Color],
                                                    background: @autoclosure @escaping () -> Background,
                                                    speed: Double = 0) -> some View {
        self
            .overlay(IrregularGradient(colors: colors,
                                       background: background(),
                                       speed: speed))
            .mask(self)
    }
}

extension Shape {
    /// Fill a shape with a gradient.
    ///
    /// - Parameters:
    ///   - colors: The colors of the blobs in the gradient. 
    ///   - background: The background view of the gradient.
    ///   - speed: The speed at which the blobs move, if they're moving.
    ///   - animate: Whether or not the blobs should move.
    public func irregularGradient<Background: View>(colors: [Color],
                                                    background: @autoclosure @escaping () -> Background,
                                                    speed: Double = 0) -> some View {
        self
            .overlay(IrregularGradient(colors: colors,
                                       background: background(),
                                       speed: speed))
            .clipShape(self)
    }
}
