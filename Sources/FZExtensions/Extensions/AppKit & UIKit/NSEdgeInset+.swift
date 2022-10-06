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

import SwiftUI

#if os(macOS)
public extension NSEdgeInsets {
    static var zero = NSEdgeInsets(0)
}
#endif
    
 extension NSUIEdgeInsets {
    var directional: NSDirectionalEdgeInsets {
        return .init(top: self.top, leading: self.left, bottom: self.bottom, trailing: self.right)
    }

    public   init(_ value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }
    
    public  init(width: CGFloat = 0.0, height: CGFloat = 0.0) {
        let wValue = width / 2.0
        let hValue = height / 2.0
        self.init(top: hValue, left: wValue, bottom: hValue, right: wValue)
    }
    
    public var width: CGFloat {
        get { return self.left + self.right }
        set {
            let value = newValue / 2.0
            self.left = value
            self.right = value
        }
    }
    
    public  var height: CGFloat {
        get { return self.top + self.bottom }
        set {
            let value = newValue / 2.0
            self.top = value
            self.bottom = value
        }
    }
}


 extension NSDirectionalEdgeInsets {
     public  static var zero = NSDirectionalEdgeInsets(0)

    public  init(_ value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }
    
     public init(width: CGFloat = 0.0, height: CGFloat = 0.0) {
        self.init()
        self.width = width
        self.height = height
    }
    
     public  var width: CGFloat {
        get { return self.leading + self.trailing }
        set {
            let value = newValue / 2.0
            self.leading = value
            self.trailing = value
        }
    }
    
     public  var height: CGFloat {
        get { return self.top + self.bottom }
        set {
            let value = newValue / 2.0
            self.top = value
            self.bottom = value
        }
    }
    
     public  var edgeInsets: EdgeInsets {
        return EdgeInsets(top: self.top, leading: self.leading, bottom: self.bottom, trailing: self.trailing)
    }
    
#if os(macOS)
     public var nsEdgeInsets: NSEdgeInsets {
        return .init(top: self.top, left: self.leading, bottom: self.bottom, right: self.trailing)
    }
#elseif canImport(UIKit)
     public  var uiEdgeInsets: NSUIEdgeInsets {
        return .init(top: self.top, left: self.leading, bottom: self.bottom, right: self.trailing)
    }
#endif
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

public extension Edge.Set {
   static var width: Self {
        return [.trailing, .trailing]
    }
   static var height: Self {
        return [.top, .bottom]
    }
}

extension EdgeInsets: Hashable {
    public static var zero: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    
   public init(_ edges: Edge.Set, _ value: CGFloat) {
        self.init(top: edges.contains(.top) ? value : 0, leading: edges.contains(.leading) ? value : 0, bottom: edges.contains(.bottom) ? value : 0, trailing: edges.contains(.trailing) ? value : 0)
    }
    
    public init(_ value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }
    
    public init(width: CGFloat, height: CGFloat) {
        self.init()
        self.width = width
        self.height = height
    }
    
    public var width: CGFloat {
        get { return self.leading + self.trailing }
        set {
            let value = newValue / 2.0
            self.leading = value
            self.trailing = value
        }
    }
    
    public var height: CGFloat {
        get { return self.top + self.bottom }
        set {
            let value = newValue / 2.0
            self.top = value
            self.bottom = value
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.top)
        hasher.combine(self.bottom)
        hasher.combine(self.leading)
        hasher.combine(self.trailing)
    }
}
