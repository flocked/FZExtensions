//
//  File.swift
//  
//
//  Created by Florian Zand on 29.08.22.
//

import Foundation
import Cocoa

open class ViewController<View: NSView>: NSViewController {
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func loadView() {
        self.view = View(frame: .zero)
    }

    public var contentView: View {
        guard let typedView = view as? View  else {
            fatalError("view property not expected type")
        }

        return typedView
    }
}
