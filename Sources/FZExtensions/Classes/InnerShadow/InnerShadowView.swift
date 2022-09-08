//
//  InnerShadowView.swift
//  VZView Demo
//
//  Created by Florian Zand on 03.09.22.
//

#if os(macOS)
import AppKit

public class InnershadowView: NSView {
    public var shadowOpacity: Float {
        get {  return innershadowLayer.shadowOpacity }
        set { innershadowLayer.shadowOpacity = newValue } }
    
    public var shadowRadius: CGFloat {
        get { innershadowLayer.shadowRadius }
        set { innershadowLayer.shadowRadius = newValue }}
        
    public var shadowOffset: CGSize {
        get { innershadowLayer.offset }
        set { innershadowLayer.offset = newValue }}
    
    public var shadowColor: NSColor?  {
        get { innershadowLayer.color }
        set { innershadowLayer.color = newValue } }
    
    public var shadowProperties: ContentProperties.Shadow {
        get { innershadowLayer.properties }
        set {  innershadowLayer.properties = newValue } }
    
    internal var innershadowLayer: InnerShadowLayer {
        self.wantsLayer = true
        let shadowLayer: InnerShadowLayer
        if let sLayer = self.layer as? InnerShadowLayer {
            shadowLayer = sLayer
        } else {
            shadowLayer = InnerShadowLayer()
            self.layer = shadowLayer
        }
        return shadowLayer
    }
    
    public override func makeBackingLayer() -> CALayer {
        let shadowLayer = InnerShadowLayer()
        return shadowLayer
    }
}
#elseif canImport(UIKit)
import UIKit
public class InnershadowView: UIView {
    public var shadowOpacity: Float {
        get {  return innershadowLayer.shadowOpacity }
        set { innershadowLayer.shadowOpacity = newValue } }
    
    public var shadowRadius: CGFloat {
        get { innershadowLayer.shadowRadius }
        set { innershadowLayer.shadowRadius = newValue }}
        
    public var shadowOffset: CGSize {
        get { innershadowLayer.offset }
        set { innershadowLayer.offset = newValue }}
    
    public var shadowColor: NSColor?  {
        get { innershadowLayer.color }
        set { innershadowLayer.color = newValue } }
    
    public var shadowProperties: ContentProperties.Shadow {
        get { innershadowLayer.properties }
        set {  innershadowLayer.properties = newValue } }
    
    internal var innershadowLayer: InnerShadowLayer {
        return self.layer as! shadowLayer
    }
    
    override class var layerClass: AnyClass {
        get { return InnerShadowLayer.self }
    }
}
#endif
