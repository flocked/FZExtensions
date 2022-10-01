//
//  File.swift
//  
//
//  Created by Florian Zand on 30.09.22.
//

import Foundation
import SwiftUI

public protocol ImageModifier {
    associatedtype Body : View
    @ViewBuilder func body(image: Image) -> Self.Body
}

public extension Image {
   func modifier<M>(_ modifier: M) -> some View where M: ImageModifier {
        modifier.body(image: self)
    }
}

