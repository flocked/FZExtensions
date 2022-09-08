//
//  VisualEffectProperties.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)

import Foundation
import AppKit

extension ContentProperties {
    
    public  struct VisualEffect: Hashable {
        var appearance: NSAppearance.Name? = nil
        var material: NSVisualEffectView.Material
        var blendingMode: NSVisualEffectView.BlendingMode
        
        static func appearance(_ appearance: NSAppearance.Name) -> VisualEffect {
            return VisualEffect(appearance: appearance, material: .popover, blendingMode: .withinWindow)
        }
        
        static func defaultVisualEffect() -> Self { return .withinWindow() }
        static func withinWindow() -> Self { return Self(appearance: nil, material: .popover, blendingMode: .withinWindow) }
        static func behindWindow() -> Self { return Self(appearance: nil, material: .popover, blendingMode: .behindWindow) }
        static func aqua() -> Self { return .appearance(.aqua) }
        static func darkAqua() -> Self { return .appearance(.darkAqua) }
        static func vibrantLight() -> Self { return .appearance(.vibrantLight) }
        static func vibrantDark() -> Self { return .appearance(.vibrantDark) }
    }
}

public extension NSVisualEffectView {
    func configurate(using properties: ContentProperties.VisualEffect) {
        self.material = properties.material
        self.blendingMode = properties.blendingMode
        if let appearanceName = properties.appearance {
            self.appearance = NSAppearance(named: appearanceName) ?? self.appearance
        }
    }
}

#endif

