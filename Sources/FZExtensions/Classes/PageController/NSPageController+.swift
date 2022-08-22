//
//  NSPageController+.swift
//  PageController
//
//  Created by Florian Zand on 26.05.22.
//

#if os(macOS)
import Foundation
import AppKit

extension NSPageController {
    typealias AdvanceType = Int.NextValueType
    
    func select(_ index: Int, duration: CGFloat = 0.0) {
        if arrangedObjects.isEmpty == false, index < arrangedObjects.count, index != selectedIndex {
            if (duration > 0.0) {
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = duration
                    self.animator().selectedIndex = index
                }, completionHandler: {
                    self.completeTransition()
                })
            } else {
                self.selectedIndex = index
                self.completeTransition()
            }
        }
    }
    
    func advance(to type: AdvanceType, duration: CGFloat = 0.0) {
        if (arrangedObjects.isEmpty == false) {
            let newIndex = self.selectedIndex.advanced(by: type, in: 0...self.arrangedObjects.count-1)
            self.select(newIndex, duration: duration)
        }
    }
}

extension NSPageController {
    enum KeyboardControl {
        case on(CGFloat = 0.0)
        case onLooping(CGFloat = 0.0)
        case off
        
        func values(for type: AdvanceType) -> (AdvanceType, CGFloat)? {
            if (type == .first || type == .last) {
                switch self {
                case .on(let value):
                    return (type, value)
                case .onLooping(let value):
                    return (type, value)
                case .off:
                    return nil
                }
            }
            switch self {
            case .on(let value):
                return ((type == .previous) ? .previous: .next, value)
            case .onLooping(let value):
                return ((type == .previous) ? .previousLooping: .nextLooping, value)
            case .off:
                return nil
            }
        }
        
        var isOn: Bool {
            switch self {
            case .off:
                return false
            default:
                return true
            }
        }
    }
}
#endif

