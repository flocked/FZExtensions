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
    func border(_ color: Color, cornerRadius: CGFloat, width: CGFloat = 1.0) -> some View {
        self.cornerRadius(cornerRadius)
            .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: width)
        )
    }
    
    func asAnyView() -> AnyView {
        return AnyView(self)
    }
}
