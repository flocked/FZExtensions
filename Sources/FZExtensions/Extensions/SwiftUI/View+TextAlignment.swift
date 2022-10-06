//
//  File.swift
//  
//
//  Created by Florian Zand on 06.10.22.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func textAlignment(_ textAlignment: TextAlignment) -> some View {
        self.modifier(TextAlignmentModifier(textAlignment: textAlignment))
    }
}

internal struct TextAlignmentModifier: ViewModifier {
    private let textAlignment: TextAlignment
    
    internal init(textAlignment: TextAlignment) {
        self.textAlignment = textAlignment
    }
    
    @ViewBuilder
    internal func body(content: Content) -> some View {
        switch textAlignment {
        case .leading:
            content
                .multilineTextAlignment(textAlignment)
                .frame(maxWidth: CGFloat.infinity, alignment: .leading)
        case .center:
            content
                .multilineTextAlignment(textAlignment)
                .frame(maxWidth: CGFloat.infinity, alignment: .center)
        case .trailing:
            content
                .multilineTextAlignment(textAlignment)
                .frame(maxWidth: CGFloat.infinity, alignment: .trailing)
        }
    }
}
