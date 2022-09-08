//
//  VisualEffectProperties.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)
import AppKit
extension ContentProperties {
    public struct VisualEffect: Hashable {
        public var appearance: NSAppearance.Name? = nil
        public var material: NSVisualEffectView.Material
        public var blendingMode: NSVisualEffectView.BlendingMode
        
        public init(appearance: NSAppearance.Name? = nil,
                    material: NSVisualEffectView.Material,
                    blendingMode: NSVisualEffectView.BlendingMode) {
            self.appearance = appearance
            self.material = material
            self.blendingMode = blendingMode
        }
        
        public static func appearance(_ appearance: NSAppearance.Name) -> VisualEffect {
            return VisualEffect(appearance: appearance, material: .popover, blendingMode: .withinWindow)
        }
        
        public static func defaultVisualEffect() -> Self { return .withinWindow() }
        public static func withinWindow() -> Self { return Self(appearance: nil, material: .popover, blendingMode: .withinWindow) }
        public static func behindWindow() -> Self { return Self(appearance: nil, material: .popover, blendingMode: .behindWindow) }
        public static func aqua() -> Self { return .appearance(.aqua) }
        public static func darkAqua() -> Self { return .appearance(.darkAqua) }
        public static func vibrantLight() -> Self { return .appearance(.vibrantLight) }
        public static func vibrantDark() -> Self { return .appearance(.vibrantDark) }
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


