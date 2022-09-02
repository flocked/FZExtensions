//
//  Magnee.swift
//  CombTest
//
//  Created by Florian Zand on 30.05.22.
//


#if os(macOS)
import Foundation
import Cocoa
import AVKit
public class MagnifyMediaView: NSView {
    private let mediaView = MediaView()
    private let scrollView = NSScrollView()

    public override var acceptsFirstResponder: Bool {
        return true
    }
    
    public var doubleClickZoomFactor: CGFloat = 0.5
    public override func mouseDown(with event: NSEvent) {
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
    
    public  override func rightMouseDown(with event: NSEvent) {
        self.mediaView.videoView.player?.togglePlayback()
    }
    
    public  override func keyDown(with event: NSEvent) {
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
    
    public  override var mouseDownCanMoveWindow: Bool {
        return true
    }
                
    public  func scroll(to point: CGPoint) {
        self.scrollView.contentView.setBoundsOrigin(point)
        self.scrollView.scroll(self.scrollView.contentView, to: point)
    }
    
    public func scroll(to point: CGPoint, animationDuration: TimeInterval) {
        self.scrollView.scroll(point, animationDuration: animationDuration)
    }
    
    public func zoomIn(factor: CGFloat = 0.5, centeredAt: CGPoint? = nil, animationDuration: TimeInterval? = nil) {
        self.zoom(factor: factor, centeredAt: centeredAt, animationDuration: animationDuration)
    }
    
    public func zoomOut(factor: CGFloat = 0.5, centeredAt: CGPoint? = nil, animationDuration: TimeInterval? = nil) {
        self.zoom(factor: -factor, centeredAt: centeredAt, animationDuration: animationDuration)
    }
    
    public func zoom(factor: CGFloat = 0.5, centeredAt: CGPoint? = nil, animationDuration: TimeInterval? = nil) {
        if allowsMagnification {
           let range = self.maxMagnification-self.minMagnification
            if (range > 0.0) {
                let factor = factor.clamped(-1.0...1.0)
                let newMag = (self.magnification + (range * factor)).clamped( self.minMagnification...self.maxMagnification)
                self.setMagnification(newMag, centeredAt: centeredAt, animationDuration: animationDuration)
            }
        }
    }
    
    public  func setMagnification(_ magnification: CGFloat, centeredAt: CGPoint? = nil, animationDuration: TimeInterval? = nil) {
        self.scrollView.setMagnification(magnification, centeredAt: centeredAt, animationDuration: animationDuration)
        if (magnification == 1.0) {
            self.scrollElasticity = .none
            self.hasScrollers = false
        } else {
            self.hasScrollers = true
            self.scrollElasticity = .automatic
        }
    }
    
    public var mediaURL: URL? {
        get {  return self.mediaView.mediaURL }
        set {
            self.mediaView.mediaURL = newValue
            self.scrollView.contentView.frame.size = self.bounds.size
            self.setMagnification(1.0)
        }
    }
    
    public  var image: NSImage? {
        get {  return self.mediaView.image }
        set {
            self.mediaView.image = newValue
            self.scrollView.contentView.frame.size = self.bounds.size
            self.setMagnification(1.0)
        }
    }
    
    public  var asset: AVAsset? {
        get {  return self.mediaView.asset }
        set {
            self.mediaView.asset = newValue
            self.scrollView.contentView.frame.size = self.bounds.size
            self.setMagnification(1.0)
        }
    }
    
    public var isMuted: Bool {
        get {  self.mediaView.isMuted }
        set { self.mediaView.isMuted = newValue } }
    
    public  var volume: Float {
        get { self.mediaView.volume  }
        set { self.mediaView.volume = newValue } }
    
    public var videoPlaybackOption: MediaView.VideoPlaybackOption {
        get { self.mediaView.videoPlaybackOption }
        set { self.mediaView.videoPlaybackOption = newValue } }
    
    public var contentScaling: CALayerContentsGravity {
        get {  mediaView.contentScaling }
        set { mediaView.contentScaling = newValue } }
    
    public func play() {
        self.mediaView.play()
    }
    
    public func pause() {
        self.mediaView.pause()
    }
    
    public  func stop() {
        self.mediaView.stop()
    }
    
    public func togglePlayback() {
        self.mediaView.togglePlayback()
    }

    public var hasScrollers: Bool {
        get { self.scrollView.hasVerticalScroller  }
        set {
            self.scrollView.hasVerticalScroller = newValue
            self.scrollView.hasHorizontalScroller = newValue
        }
    }
    
    public  var scrollElasticity: NSScrollView.Elasticity {
        get {  self.scrollView.verticalScrollElasticity }
        set {
            self.scrollView.verticalScrollElasticity = newValue
            self.scrollView.horizontalScrollElasticity = newValue
        }
    }
    
    public var allowsMagnification: Bool {
        get { self.scrollView.allowsMagnification }
        set { self.scrollView.allowsMagnification = newValue } }
    
    public  var magnification: CGFloat {
        get { self.scrollView.magnification }
        set { self.setMagnification(newValue) } }
    
    public  var minMagnification: CGFloat {
        get { self.scrollView.minMagnification }
        set { self.scrollView.minMagnification = newValue } }
    
    public  var maxMagnification: CGFloat {
        get { self.scrollView.maxMagnification }
        set { self.scrollView.maxMagnification = newValue } }
    
    public override var enclosingScrollView: NSScrollView? {
        return self.scrollView
    }
    
    public init(mediaURL: URL) {
        super.init(frame: .zero)
        self.mediaURL = mediaURL
    }
    
    public  init(frame: CGRect, mediaURL: URL) {
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
    
   private func sharedInit() {
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
