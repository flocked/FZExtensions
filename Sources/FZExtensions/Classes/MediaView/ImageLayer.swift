//
//  NewImageLayer.swift
//  FZCollection
//
//  Created by Florian Zand on 30.05.22.
//


#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import Combine

public class ImageLayer: CALayer {
    public  var contentTintColor: NSUIColor? = nil {
        didSet {
            self.updateDisplayingImageSymbolConfiguration()
        }
    }
    
    public var image: NSUIImage?  {
        get {  self.images.first }
        set {
            if let newImage = newValue {
#if os(macOS)
                if (newImage.isAnimatable) {
                    self.setGif(image: newImage)
                } else {
                    if #available(macOS 12.0, *) {
                        if newImage.isSymbolImage, let symbolConfiguration = symbolConfiguration, let updatedImage = newImage.applyingSymbolConfiguration(symbolConfiguration) {
                            self.images = [updatedImage]
                        } else {
                            self.images = [newImage]
                        }
                    } else {
                    self.images = [newImage]
                    }
                }
#else
                if #available(iOS 15.0, *) {
                    if newImage.isSymbolImage, let symbolConfiguration = symbolConfiguration, let updatedImage = newImage.applyingSymbolConfiguration(symbolConfiguration) {
                        self.images = [updatedImage]
                    } else {
                        self.images = [newImage]
                    }
                } else {
                    self.images = [newImage]
                }
#endif
                
            } else {
                self.images = []
            }
        }
    }
    
    public var displayingImage: NSUIImage? {
        if (self.currentIndex > -1 && self.currentIndex < self.images.count) {
            return self.images[currentIndex]
        }
            return nil
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
    
    internal func updateDisplayingImageSymbolConfiguration() {
        if #available(macOS 12.0, iOS 15.0, *) {
            if contentTintColor != nil {
            if let image = self.displayingImage, image.isSymbolImage, let updatedImage = applyingSymbolConfiguration(to: image) {
                self.images[self.currentIndex] = updatedImage
                self.updateDisplayingImage()
            }
        }
        }
    }
    
    @available(macOS 12.0, iOS 15.0, *)
    internal func applyingSymbolConfiguration(to image: NSUIImage) -> NSUIImage? {
        var configuration: NSUIImage.SymbolConfiguration? = nil
        /*
        if let symbolConfiguration = symbolConfiguration {
           configuration = symbolConfiguration
        }
        
        if let contentTintColor = contentTintColor {
            let tintConfiguration = NSUIImage.SymbolConfiguration.palette(contentTintColor)
            configuration = configuration?.applying(tintConfiguration) ?? tintConfiguration

        }
        */
        
#if os(macOS)
        if let contentTintColor = contentTintColor?.resolvedColor() {
            configuration = NSUIImage.SymbolConfiguration.palette(contentTintColor)
        }
#else
        if let contentTintColor = contentTintColor {
            configuration = NSUIImage.SymbolConfiguration.palette(contentTintColor)
        }
#endif
        
        if let symbolConfiguration = symbolConfiguration {
            configuration = configuration?.applying(symbolConfiguration) ?? symbolConfiguration
        }
        
        if let configuration = configuration {
           return image.applyingSymbolConfiguration(configuration)
        }
        return nil
    }
    
    internal var _symbolConfiguration: Any? = nil
    @available(macOS 12.0, iOS 15.0, *)
    public var symbolConfiguration: NSUIImage.SymbolConfiguration? {
        get { _symbolConfiguration as? NSUIImage.SymbolConfiguration }
        set { _symbolConfiguration = newValue
            updateDisplayingImageSymbolConfiguration()
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
    
#if os(macOS)
    public func setGif(image: NSImage) {
        if let frames = image.frames() {
            var duration = 0.0
            for frame in frames {
                duration = duration + frame.duration
            }
            self.animationDuration = duration
            self.images = frames.compactMap({$0.image})
        }
    }
#endif
            
   private var currentIndex = 0 {
        didSet {
            self.updateDisplayingImage()
        }
    }
    
    private func updateDisplayingImage() {
        CATransaction.perform(animated: false, animations: {
            self.contents = displayingImage
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
    
    public var fittingSize: CGSize {
        if let imageSize = self.images.first?.size {
            return imageSize
        }
        return .zero
    }
    
    public func sizeThatFits(_ size: CGSize) -> CGSize {
        if let imageSize = self.images.first?.size {
            if (imageSize.width <= size.width && imageSize.height <= size.height) {
                return imageSize
            } else {
                switch self.imageScaling {
                case .resizeAspect:
                    if (size.width == .infinity) {
                        return imageSize.scaled(toHeight: size.height)
                    } else if (size.height == .infinity) {
                        return imageSize.scaled(toWidth: size.width)
                    }
                    return imageSize.scaled(toFit: size)
                default:
                    return size
                }
            }
        }
        return .zero
    }
    
    public func sizeToFit() {
        self.frame.size = self.fittingSize
    }
    
    public  init(image: NSUIImage) {
        super.init()
        self.image = image
    }
    
    public init(layer: CALayer, image: NSUIImage) {
        super.init(layer: layer)
        self.image = image
    }
    
    public init(images: [NSUIImage]) {
        super.init()
        self.images = images
    }
    
    public init(layer: CALayer, images: [NSUIImage]) {
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
    
    public struct Trans {
        var type: TransitionType = .fade
        var duration: CGFloat = 0.1
        internal var caTransition: CATransition? {
            guard duration != 0.0 else { return nil }
            let transition = CATransition()
            transition.type = self.type.caTransitionType
            transition.duration = self.duration
            return transition
        }
        public enum TransitionType {
            case push
            case fade
            case moveIn
            case reveal
            
            internal var caTransitionType: CATransitionType {
                 switch self {
                 case .push:
                     return .push
                 case .fade:
                     return .fade
                 case .moveIn:
                     return .moveIn
                 case .reveal:
                     return .reveal
                 }
             }
        }
    }
    
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
