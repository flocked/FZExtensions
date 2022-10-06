//
//  NSWindow+.swift
//  FZExtensions
//
//  Created by Florian Zand on 12.08.22.
//

#if canImport(UIKit)
import UIKit

extension UIView.ContentMode : CaseIterable {
    public static var allCases: [UIView.ContentMode] = [.scaleToFill, .scaleAspectFit, .scaleAspectFill, .redraw, .center, .top, .bottom, .left, .right, .topLeft, .topRight, .bottomLeft, .bottomRight]
}

public extension UIView.ContentMode {
    var layerContentsGravity : CALayerContentsGravity {
        switch self {
        case .scaleToFill: return .resizeAspectFill
        case .scaleAspectFit: return .resizeAspectFill
        case .scaleAspectFill: return .resizeAspectFill
        case .redraw: return .resizeAspectFill
        case .center: return .center
        case .top: return .top
        case .bottom: return .bottom
        case .left: return .left
        case .right: return .right
        case .topLeft: return .left
        case .topRight: return .right
        case .bottomLeft: return .left
        case .bottomRight: return .right
        }
    }
    
    init(contentsGravity: CALayerContentsGravity) {
        let rawValue = NSImageScaling.allCases.first(where: {$0.layerContentsGravity == contentsGravity})?.rawValue ?? UIView.ContentType.scaleToFill.rawValue
        self.init(rawValue: rawValue)!
    }
}

#endif
