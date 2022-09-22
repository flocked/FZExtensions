//
//  NewImageLayer.swift
//  FZCollection
//
//  Created by Florian Zand on 30.05.22.
//


#if os(macOS)
import AppKit
import Foundation
import Combine

public class ImageLayer: CALayer {
    public  var contentTintColor: NSColor? = nil {
        didSet {
        }
    }
    
    public var image: NSUIImage?  {
        get {
            self.images.first
        }
        set {
            if let newImage = newValue {
                if (newImage.isGif) {
                    self.setGif(image: newImage)
                } else {
                    self.images = [newImage]
                }
            } else {
                self.images = []
            }
        }
    }

    
    public var images: [NSUIImage] = [] {
        didSet {
            if (isAnimating && !isAnimatable) {
                stopAnimating()
            }
            self.setFrame(to: .first)
            self.updateDisplayingImage()
            if (isAnimatable && !isAnimating && autoAnimates) {
                self.startAnimating()
            }
        }
    }
    
        
    public  var imageScaling: CALayerContentsGravity {
        get {
           return self.contentsGravity
        }
        set {
            self.contentsGravity = newValue
        }
    }
    
    public  var autoAnimates: Bool = true {
        didSet {
            if (isAnimatable && !isAnimating && autoAnimates) {
                self.startAnimating()
            }
        }
    }
        
    public  var animationDuration: TimeInterval = 0.0
    
    public var isAnimating: Bool {
        return (displayLink != nil)
    }
    
    private var dlPreviousTimestamp: TimeInterval = 0.0
    private var dlCount: TimeInterval = 0.0
    public func startAnimating() {
        if (isAnimatable) {
            if (!isAnimating) {
                self.dlPreviousTimestamp = 0.0
                self.dlCount = 0.0
                self.displayLink = DisplayLink.shared.sink(receiveValue: {[weak self]
                    frame in
                    if let self = self {
                        let timeIntervalCount = frame.timestamp - self.dlPreviousTimestamp
                        self.dlCount = self.dlCount + timeIntervalCount
                        if (self.dlCount > self.timerInterval*2.0) {
                            self.dlCount = 0.0
                            self.setFrame(to: .next)
                            self.dlPreviousTimestamp = frame.timestamp
                        }
                    }
                })
                }
            }
        }
    
    public  func pauseAnimating() {
        self.displayLink?.cancel()
        self.displayLink = nil
    }
    
    public  func stopAnimating() {
        self.displayLink?.cancel()
        self.displayLink = nil
        self.setFrame(to: .first)
    }
    
    public func toggleAnimating() {
        if (self.isAnimatable) {
            if (self.isAnimating) {
                self.pauseAnimating()
            } else {
                self.startAnimating()
            }
        }
    }
    
    public  enum FrameOption {
        case first
        case last
        case random
        case next
        case previous
    }
    
    public  func setFrame(to option: FrameOption) {
        if (self.images.isEmpty == false) {
        switch option {
        case .first:
            self.currentIndex = 0
        case .last:
            self.currentIndex = self.images.count - 1
        case .random:
            self.currentIndex = Int.random(in: 0...images.count - 1)
        case .next:
            self.currentIndex = self.currentIndex.nextLooped(in: 0...images.count-1)
        case .previous:
            self.currentIndex = self.currentIndex.previousLooped(in: 0...images.count-1)
        }
        } else {
            self.currentIndex = -1
        }
    }
    
    
    public func setGif(image: NSImage) {
        if let frames = image.gifFrames() {
            var duration = 0.0
            for frame in frames {
                duration = duration + frame.duration
            }
            self.animationDuration = duration
            self.images = frames.compactMap({$0.image})
        }
    }

    
            
   private var currentIndex = 0 {
        didSet {
            self.updateDisplayingImage()
        }
    }
    
    private func updateDisplayingImage() {
        CATransaction.perform(animated: false, animations: {
            if (self.currentIndex > -1 && self.currentIndex < self.images.count) {
                self.contents = self.images[currentIndex]
            } else {
                self.contents = nil
            }
        })
    }
    
    
    private var displayLink: AnyCancellable? = nil
    private var timeStamp: TimeInterval = 0

    
    private var timerInterval: TimeInterval {
        if (animationDuration == 0.0) {
            return ImageSource.defaultFrameDuration
        } else {
            return animationDuration / Double(images.count)
        }
    }
    
   private var isAnimatable: Bool {
        return (images.count > 1)
    }
    
    public var fittingSize: NSSize {
        if let imageSize = self.images.first?.size {
            return imageSize
        }
        return .zero
    }
    
    public func sizeToFit() {
        self.frame.size = self.fittingSize
    }
    
    public  init(image: NSImage) {
        super.init()
        self.image = image
    }
    
    public init(layer: CALayer, image: NSImage) {
        super.init(layer: layer)
        self.image = image
    }
    
    public init(images: [NSImage]) {
        super.init()
        self.images = images
    }
    
    public init(layer: CALayer, images: [NSImage]) {
        super.init(layer: layer)
        self.images = images
    }
    
    override init() {
         super.init()
        self.sharedInit()
     }
    
     override init(layer: Any) {
         super.init(layer: layer)
         self.sharedInit()
     }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sharedInit()
    }
    
  private  func sharedInit() {
        self.isOpaque = true
        self.contentsGravity = .resizeAspect
    }
    
    public var transition: Transition = .none {
        didSet {
          //  updateTransitionAnimation()
        }
    }
    
    /*
    private func updateTransitionAnimation() {
        if let transition = self.transition.caTransition, transition.duration != 0.0 {
              self.removeAnimation(forKey: "transition")
              self.transitionAnimation = transition
          } else {
              self.transitionAnimation = nil
          }
      }
    */
    
    public enum Transition {
        case none
        case push(CGFloat)
        case fade(CGFloat)
        case moveIn(CGFloat)
        case reveal(CGFloat)
        
       fileprivate var caTransition: CATransition? {
            switch self {
            case .none:
                return nil
            case .push(let duration):
                return CATransition(.push, duration)
            case .fade(let duration):
                return CATransition(.fade, duration)
            case .moveIn(let duration):
                return CATransition(.moveIn, duration)
            case .reveal(let duration):
                return CATransition(.reveal, duration)
            }
        }
    }
    
}
#endif
