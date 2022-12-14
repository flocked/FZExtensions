#if os(macOS)

import AppKit

public extension NSView {
    enum ConstraintMode {
        case autoresizingMask
        case layoutConstraints
    }
    
    enum ConstraintValueMode {
        case relative
        case absolute
        case full
        case insets(NSEdgeInsets)
        public static func insets(_ directionalEdgeInsets: NSDirectionalEdgeInsets) -> ConstraintValueMode {
            return .insets(directionalEdgeInsets.nsEdgeInsets)
        }
        
        internal var autoresizingMask: NSView.AutoresizingMask {
            switch self {
            case .relative:
                return [.height, .width]
            default:
                return .all
            }
        }
    }
    
    @discardableResult
    func addSubview(_ view: NSView,  constraint: ConstraintValueMode, using mode: ConstraintMode = .layoutConstraints) -> [NSLayoutConstraint] {
        switch mode {
        case .autoresizingMask:
            view.translatesAutoresizingMaskIntoConstraints = true
            switch constraint {
            case .full:
                view.frame = self.bounds
            case .insets(let insets):
                let width = insets.right - insets.left
                let height = insets.top - insets.bottom
                view.frame = CGRect(x: insets.bottom, y: insets.left, width: width, height: height)
            default:
                break
            }
            self.addSubview(view)
            view.autoresizingMask = constraint.autoresizingMask
            return []
        case .layoutConstraints:
            let constants: [CGFloat]
            switch constraint {
            case .absolute:
                constants = calculateConstants(view)
            case .insets(let insets):
                constants = [insets.left, insets.bottom, 0.0-insets.right, 0.0-insets.top]
            default:
                constants = [0, 0, 0, 0]
            }
            let multipliers: [CGFloat]
            switch constraint {
            case .relative:
                multipliers = calculateMultipliers(view)
            default:
                multipliers = [1.0, 1.0 , 1.0, 1.0]
            }
            
            self.addSubview(view)
            switch constraint {
            case .full:
                view.frame = self.bounds
            default:
                break
            }
            
            view.translatesAutoresizingMaskIntoConstraints = false
            let left: NSLayoutConstraint = .init(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: multipliers[0], constant: constants[0])
            let bottom: NSLayoutConstraint = .init(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: multipliers[1], constant: constants[1])
            let width: NSLayoutConstraint = .init(item: view, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: multipliers[2], constant: constants[2])
            let height: NSLayoutConstraint = .init(item: view, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: multipliers[3], constant: constants[3])
            let constraints = [left, bottom, width, height]
            NSLayoutConstraint.activate(constraints)
            return constraints
        }
    }
    
    internal func calculateMultipliers(_ view: NSView) -> [CGFloat] {
        let x = view.frame.x / self.bounds.width
        let y = view.frame.y / self.bounds.height
        let width = view.frame.width / self.bounds.width
        let height = view.frame.height / self.bounds.height
        return [x, y, width, height]
    }
    
    internal func calculateConstants(_ view: NSView) -> [CGFloat] {
        let x = view.frame.minX
        let y = -view.frame.minY
        let width = view.frame.width - self.bounds.width
        let height = view.frame.height - self.bounds.height
        return [x, y, width, height]
    }
    
}

#endif
