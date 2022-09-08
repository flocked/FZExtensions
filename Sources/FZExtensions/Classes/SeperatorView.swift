//
//  SeperatorView.swift
//  IListContentConfiguration
//
//  Created by Florian Zand on 08.09.22.
//

#if os(macOS)
import AppKit

public class SeperatorView: NSView, NSCollectionViewElement {
    public var color: NSColor = .black
    public var leadingInset: CGFloat = 0.0
    public var trailingInset: CGFloat = 0.0
    public var opacity: CGFloat = 1.0
    internal var leadingConstraint: NSLayoutConstraint!
    internal var trailingConstraint: NSLayoutConstraint!

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    internal let seperatorView = NSView()
    
    internal func setup() {
        let constraints = self.addSubview(withConstraint: seperatorView)
        leadingConstraint = constraints[2]
        trailingConstraint = constraints[3]
        self.updateSeperator()
    }
    
    internal func updateSeperator() {
        seperatorView.backgroundColor = color
        seperatorView.alpha = opacity
        self.leadingConstraint.constant = self.leadingInset
        self.trailingConstraint.constant = self.trailingInset
    }
}
#endif
