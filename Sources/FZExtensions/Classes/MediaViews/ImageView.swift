//
//  NewImageVIew.swift
//  FZCollection
//
//  Created by Florian Zand on 30.05.22.
//

#if os(macOS)
import Foundation
import AppKit

class ImageView: NSView {
    var image: NSImage?  {
        get {
            self.imageLayer.image
        }
        set {
            self.imageLayer.image = newValue
        }
    }
    
    var images: [NSImage] {
        get {
            self.imageLayer.images
        }
        set {
            self.imageLayer.images = newValue
        }
    }
        
    var imageScaling: CALayerContentsGravity {
        get {
            self.imageLayer.imageScaling
        }
        set {
            self.imageLayer.imageScaling = newValue
        }
    }
    
    var autoAnimates: Bool  {
        get {
            self.imageLayer.autoAnimates
        }
        set {
            self.imageLayer.autoAnimates = newValue
        }
    }
    
    var animationDuration: TimeInterval {
        get {
            self.imageLayer.animationDuration
        }
        set {
            self.imageLayer.animationDuration = newValue
        }
    }
    
    var isAnimating: Bool {
        return imageLayer.isAnimating
    }
    
    func startAnimating() {
        imageLayer.startAnimating()
    }
    
    func pauseAnimating() {
        imageLayer.pauseAnimating()
    }
    
    func stopAnimating() {
        imageLayer.stopAnimating()
    }
    
    func toggleAnimating() {
        imageLayer.toggleAnimating()
    }

    func setFrame(to option: ImageLayer.FrameOption) {
        imageLayer.setFrame(to: option)
    }
    
    func setGif(image: NSImage) {
        imageLayer.setGif(image: image)
    }
            
    override var fittingSize: NSSize {
        return imageLayer.fittingSize
    }
    
    func sizeToFit() {
        self.frame.size = self.fittingSize
    }
    
    private let imageLayer = ImageLayer()
    
    override func makeBackingLayer() -> CALayer {
        return imageLayer
    }
    
    init(image: NSImage) {
        super.init(frame: .zero)
        self.image = image
    }
    
    init(image: NSImage, frame: CGRect) {
        super.init(frame: frame)
        self.image = image
    }
    
    init(images: [NSImage]) {
        super.init(frame: .zero)
        self.images = images
    }
    
    init(images: [NSImage], frame: CGRect) {
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
    
    func sharedInit() {
        self.wantsLayer = true
        self.imageScaling = .resizeAspect
        self.layerContentsRedrawPolicy = .onSetNeedsDisplay
    }
    
    override var wantsUpdateLayer: Bool {
        return true
    }
    
}
#endif
