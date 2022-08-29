//
//  NewImageVIew.swift
//  FZCollection
//
//  Created by Florian Zand on 30.05.22.
//

#if os(macOS)
import Foundation
import AppKit

public class ImageView: NSView {
    public var image: NSImage?  {
        get {
            self.imageLayer.image
        }
        set {
            self.imageLayer.image = newValue
        }
    }
    
    public var images: [NSImage] {
        get {
            self.imageLayer.images
        }
        set {
            self.imageLayer.images = newValue
        }
    }
        
    public var imageScaling: CALayerContentsGravity {
        get {
            self.imageLayer.imageScaling
        }
        set {
            self.imageLayer.imageScaling = newValue
        }
    }
    
    public  var autoAnimates: Bool  {
        get {
            self.imageLayer.autoAnimates
        }
        set {
            self.imageLayer.autoAnimates = newValue
        }
    }
    
    public  var animationDuration: TimeInterval {
        get {
            self.imageLayer.animationDuration
        }
        set {
            self.imageLayer.animationDuration = newValue
        }
    }
    
    public  var isAnimating: Bool {
        return imageLayer.isAnimating
    }
    
    public  func startAnimating() {
        imageLayer.startAnimating()
    }
    
    public func pauseAnimating() {
        imageLayer.pauseAnimating()
    }
    
    public func stopAnimating() {
        imageLayer.stopAnimating()
    }
    
    public func toggleAnimating() {
        imageLayer.toggleAnimating()
    }

    public  func setFrame(to option: ImageLayer.FrameOption) {
        imageLayer.setFrame(to: option)
    }
    
    public  func setGif(image: NSImage) {
        imageLayer.setGif(image: image)
    }
            
    public  override var fittingSize: NSSize {
        return imageLayer.fittingSize
    }
    
    public func sizeToFit() {
        self.frame.size = self.fittingSize
    }
    
    private let imageLayer = ImageLayer()
    
    public override func makeBackingLayer() -> CALayer {
        return imageLayer
    }
    
    public init(image: NSImage) {
        super.init(frame: .zero)
        self.image = image
    }
    
    public init(image: NSImage, frame: CGRect) {
        super.init(frame: frame)
        self.image = image
    }
    
    public  init(images: [NSImage]) {
        super.init(frame: .zero)
        self.images = images
    }
    
    public init(images: [NSImage], frame: CGRect) {
        super.init(frame: frame)
        self.images = images
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sharedInit()
    }
    
   private func sharedInit() {
        self.wantsLayer = true
        self.imageScaling = .resizeAspect
   //     self.layerContentsRedrawPolicy = .onSetNeedsDisplay
    }
    
    /*
    public override var wantsUpdateLayer: Bool {
        return true
    }
    */
    
}
#endif
