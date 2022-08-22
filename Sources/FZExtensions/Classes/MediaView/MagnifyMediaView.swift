//
//  Magnee.swift
//  CombTest
//
//  Created by Florian Zand on 30.05.22.
//

import Foundation
import Cocoa
import AVKit

#if os(macOS)
class MagnifyMediaView: NSView {
    private let mediaView = MediaView()
    private let scrollView = NSScrollView()

    override var acceptsFirstResponder: Bool {
        return true
    }
    
    var doubleClickZoomFactor: CGFloat = 0.5
    override func mouseDown(with event: NSEvent) {
        self.window?.makeFirstResponder(self)
        if event.clickCount == 2 {
            if (self.magnification != 1.0) {
                self.setMagnification(1.0)
            } else {
                let mousePoint = event.location(in: self)
                self.zoomIn(factor: self.doubleClickZoomFactor, centeredAt: mousePoint)
            }
        }
    }
    
    override func rightMouseDown(with event: NSEvent) {
        self.mediaView.videoView.player?.togglePlayback()
    }
    
    override func keyDown(with event: NSEvent) {
        if (event.keyCode == 30) { // Zoom In
            if (event.modifierFlags.contains(.command)) {
                self.setMagnification(self.maxMagnification)
            } else {
                self.zoomIn(factor: 0.3)
            }
        } else if (event.keyCode == 44) { // Zoom Out
            if (event.modifierFlags.contains(.command)) {
              //  self.setMagnification(self.minMagnification, animationDuration: 0.1)
                self.setMagnification(1.0)
            } else {
                self.zoomOut(factor: 0.3)
            }
        } else {
            super.keyDown(with: event)
        }
    }
    
    override var mouseDownCanMoveWindow: Bool {
        return true
    }
                
    func scroll(to point: CGPoint) {
        self.scrollView.contentView.setBoundsOrigin(point)
        self.scrollView.scroll(self.scrollView.contentView, to: point)
    }
    
    func scroll(to point: CGPoint, animationDuration: TimeInterval) {
        self.scrollView.scroll(point, animationDuration: animationDuration)
    }
    
    func zoomIn(factor: CGFloat = 0.5, centeredAt: CGPoint? = nil, animationDuration: TimeInterval? = nil) {
        self.zoom(factor: factor, centeredAt: centeredAt, animationDuration: animationDuration)
    }
    
    func zoomOut(factor: CGFloat = 0.5, centeredAt: CGPoint? = nil, animationDuration: TimeInterval? = nil) {
        self.zoom(factor: -factor, centeredAt: centeredAt, animationDuration: animationDuration)
    }
    
    func zoom(factor: CGFloat = 0.5, centeredAt: CGPoint? = nil, animationDuration: TimeInterval? = nil) {
        if allowsMagnification {
           let range = self.maxMagnification-self.minMagnification
            if (range > 0.0) {
                let factor = factor.clamped(-1.0...1.0)
                let newMag = (self.magnification + (range * factor)).clamped( self.minMagnification...self.maxMagnification)
                self.setMagnification(newMag, centeredAt: centeredAt, animationDuration: animationDuration)
            }
        }
    }
    
    func setMagnification(_ magnification: CGFloat, centeredAt: CGPoint? = nil, animationDuration: TimeInterval? = nil) {
        self.scrollView.setMagnification(magnification, centeredAt: centeredAt, animationDuration: animationDuration)
        if (magnification == 1.0) {
            self.scrollElasticity = .none
            self.hasScrollers = false
        } else {
            self.hasScrollers = true
            self.scrollElasticity = .automatic
        }
    }
    
    var mediaURL: URL? {
        get {  return self.mediaView.mediaURL }
        set {
            self.mediaView.mediaURL = newValue
            self.scrollView.contentView.frame.size = self.bounds.size
            self.setMagnification(1.0)
        }
    }
    
    var image: NSImage? {
        get {  return self.mediaView.image }
        set {
            self.mediaView.image = newValue
            self.scrollView.contentView.frame.size = self.bounds.size
            self.setMagnification(1.0)
        }
    }
    
    var asset: AVAsset? {
        get {  return self.mediaView.asset }
        set {
            self.mediaView.asset = newValue
            self.scrollView.contentView.frame.size = self.bounds.size
            self.setMagnification(1.0)
        }
    }
    
    var isMuted: Bool {
        get {  self.mediaView.isMuted }
        set { self.mediaView.isMuted = newValue } }
    
    var volume: Float {
        get { self.mediaView.volume  }
        set { self.mediaView.volume = newValue } }
    
    var videoPlaybackOption: MediaView.VideoPlaybackOption {
        get { self.mediaView.videoPlaybackOption }
        set { self.mediaView.videoPlaybackOption = newValue } }
    
    var contentScaling: CALayerContentsGravity {
        get {  mediaView.contentScaling }
        set { mediaView.contentScaling = newValue } }
    
    func play() {
        self.mediaView.play()
    }
    
    func pause() {
        self.mediaView.pause()
    }
    
    func stop() {
        self.mediaView.stop()
    }
    
    func togglePlayback() {
        self.mediaView.togglePlayback()
    }

     var hasScrollers: Bool {
        get { self.scrollView.hasVerticalScroller  }
        set {
            self.scrollView.hasVerticalScroller = newValue
            self.scrollView.hasHorizontalScroller = newValue
        }
    }
    
     var scrollElasticity: NSScrollView.Elasticity {
        get {  self.scrollView.verticalScrollElasticity }
        set {
            self.scrollView.verticalScrollElasticity = newValue
            self.scrollView.horizontalScrollElasticity = newValue
        }
    }
    
    var allowsMagnification: Bool {
        get { self.scrollView.allowsMagnification }
        set { self.scrollView.allowsMagnification = newValue } }
    
      var magnification: CGFloat {
        get { self.scrollView.magnification }
        set { self.setMagnification(newValue) } }
    
      var minMagnification: CGFloat {
        get { self.scrollView.minMagnification }
        set { self.scrollView.minMagnification = newValue } }
    
     var maxMagnification: CGFloat {
        get { self.scrollView.maxMagnification }
        set { self.scrollView.maxMagnification = newValue } }
    
    override var enclosingScrollView: NSScrollView? {
        return self.scrollView
    }
    
    init(mediaURL: URL) {
        super.init(frame: .zero)
        self.mediaURL = mediaURL
    }
    
    init(frame: CGRect, mediaURL: URL) {
        super.init(frame: frame)
        self.mediaURL = mediaURL
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
        mediaView.wantsLayer = true
        mediaView.frame = self.bounds
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.frame = self.bounds
        self.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.scrollView.contentView = CenteredClipView()
        
        scrollView.contentView.frame.size = CGSize(width: 50, height: 50)
        self.scrollView.drawsBackground = false
        
        mediaView.frame = scrollView.contentView.bounds
        mediaView.autoresizingMask = .all
        
        self.scrollView.documentView = mediaView

        self.allowsMagnification = true
        self.contentScaling = .resizeAspect
        self.minMagnification = 1.0
        self.maxMagnification = 3.0
        self.backgroundColor = .black
        self.enclosingScrollView?.backgroundColor = .black
    }
}

fileprivate class CenteredClipView: NSClipView {
    override func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {
        var rect = super.constrainBoundsRect(proposedBounds)

        if let containerView = documentView {
            if rect.size.width > containerView.frame.size.width {
                rect.origin.x = (containerView.frame.width - rect.width ) / 2
            }

            if rect.size.height > containerView.frame.size.height {
                rect.origin.y = (containerView.frame.height - rect.height ) / 2
            }
        }

        return rect
    }
}
#endif
