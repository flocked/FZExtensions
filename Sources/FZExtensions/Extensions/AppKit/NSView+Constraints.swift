#if os(macOS)

import AppKit

public extension NSView {
     enum ConstraintMode {
        case relative
        case absolute
        case full
    }

    @discardableResult
    func addSubview(_ view: NSView,  constraint: ConstraintMode) -> [NSLayoutConstraint] {
        let constants: [CGFloat] = (constraint == .absolute) ? calculateConstants(view) : [0, 0, 0, 0]
        let multipliers: [CGFloat] = (constraint == .relative) ? calculateMultipliers(view) : [1.0, 1.0 , 1.0, 1.0]

        self.addSubview(view)
        if (constraint == .full) {
            view.frame = self.bounds
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
