//
//  NSEdgeInset+.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if os(macOS)
public extension NSEdgeInsets {
    static var zero = NSEdgeInsets(0)
}
#endif
    
public extension NSUIEdgeInsets {
    var directional: NSDirectionalEdgeInsets {
        return .init(top: self.top, leading: self.left, bottom: self.bottom, trailing: self.right)
    }

    init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
    init(width: CGFloat = 0.0, height: CGFloat = 0.0) {
        let wValue = width / 2.0
        let hValue = height / 2.0
        self.init(top: hValue, left: wValue, bottom: hValue, right: wValue)
    }
    
    var width: CGFloat {
        get { return self.left + self.right }
        set {
            let value = newValue / 2.0
            self.left = value
            self.right = value
        }
    }
    
    var height: CGFloat {
        get { return self.top + self.bottom }
        set {
            let value = newValue / 2.0
            self.top = value
            self.bottom = value
        }
    }
}


public extension NSDirectionalEdgeInsets {
    static var zero = NSDirectionalEdgeInsets(0)

    init(_ value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }
    
    init(width: CGFloat = 0.0, height: CGFloat = 0.0) {
        let wValue = width / 2.0
        let hValue = height / 2.0
        self.init(top: hValue, leading: wValue, bottom: hValue, trailing: wValue)
    }
    
    var width: CGFloat {
        get { return self.leading + self.trailing }
        set {
            let value = newValue / 2.0
            self.leading = value
            self.trailing = value
        }
    }
    
    var height: CGFloat {
        get { return self.top + self.bottom }
        set {
            let value = newValue / 2.0
            self.top = value
            self.bottom = value
        }
    }
    
    var edgeInsets: NSUIEdgeInsets {
        return .init(top: self.top, left: self.leading, bottom: self.bottom, right: self.trailing)
    }
}


 extension NSDirectionalEdgeInsets: Hashable {
    public static func == (lhs: NSDirectionalEdgeInsets, rhs: NSDirectionalEdgeInsets) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.top)
        hasher.combine(self.bottom)
        hasher.combine(self.trailing)
        hasher.combine(self.leading)

    }
}
