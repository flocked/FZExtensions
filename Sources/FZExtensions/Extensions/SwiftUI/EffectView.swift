//
//  BlurView.swift
//  AuroraEditorModules/AuroraEditorUI
//
//  Created by Rehatbir Singh on 15/03/2022.
//

import SwiftUI

public struct EffectView: NSViewRepresentable {
    private let material: NSVisualEffectView.Material
    private let blendingMode: NSVisualEffectView.BlendingMode
    private let emphasized: Bool

    public init(
        _ material: NSVisualEffectView.Material = .headerView,
        blendingMode: NSVisualEffectView.BlendingMode = .withinWindow,
        emphasized: Bool = false
    ) {
        self.material = material
        self.blendingMode = blendingMode
        self.emphasized = emphasized
    }

    public func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.isEmphasized = emphasized
        view.state = .followsWindowActiveState
        return view
    }

    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }

    @ViewBuilder
    public static func selectionBackground(_ condition: Bool = true) -> some View {
        if condition {
            EffectView(.selection, blendingMode: .withinWindow, emphasized: true)
        } else {
            Color.clear
        }
    }
}
