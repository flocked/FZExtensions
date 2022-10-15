//
//  NewImageVIew.swift
//  FZCollection
//
//  Created by Florian Zand on 30.05.22.
//

#if os(macOS)
import Foundation
import AppKit
import AVKit

public class MediaView: NSView {
    public enum VideoPlaybackOption {
        case autostart
        case previousPlaybackState
        case off
    }
    
   public var autoAnimatesImages: Bool {
        get { imageView.autoAnimates }
        set { imageView.autoAnimates = newValue }
    }
    
    public var overlayView: NSView? = nil {
        didSet {
            if let overlayView = overlayView, oldValue != overlayView {
                oldValue?.removeFromSuperview()
                self.addSubview(withConstraint: overlayView)
            } else {
                oldValue?.removeFromSuperview()
            }
        }
    }
    
    public  var contentTintColor: NSColor? {
        get { self.imageView.contentTintColor  }
        set { self.imageView.contentTintColor  = newValue  }
    }

    public var loopVideos: Bool = true
    public var isMuted: Bool = false { didSet { self.updateVideoViewConfiguration() } }
    public var volume: Float = 0.2  { didSet { self.updateVideoViewConfiguration() } }
    public var videoPlaybackOption: VideoPlaybackOption = .autostart
    public var videoViewControlStyle:  AVPlayerViewControlsStyle = .inline {
        didSet { self.updateVideoViewConfiguration() } }
    
    public var contentScaling: CALayerContentsGravity = .resizeAspect {
        didSet {
            self.imageView.imageScaling = self.contentScaling
            self.videoView.videoGravity = AVLayerVideoGravity(caLayerContentsGravity: self.contentScaling) ?? .resizeAspectFill
        }
    }
    
    public private(set) var mediaType: URL.FileType? = nil
    
    public var mediaURL: URL? = nil {
        didSet {
            if let mediaURL = self.mediaURL {
                self.updatePreviousPlaybackState()
                if (mediaURL.fileType == .video) {
                    self.asset = AVAsset(url: mediaURL)
                } else if (mediaURL.fileType == .image || mediaURL.fileType == .gif),  let image = NSImage(contentsOf: mediaURL) {
                    self.image = image
                } else {
                    self.mediaType = nil
                    self.mediaURL = nil
                    self.hideImageView()
                    self.hideVideoView()
                }
            } else {
                self.mediaType = nil
                self.hideImageView()
                self.hideVideoView()
            }
        }
    }
    
    public var asset: AVAsset? {
        get {
            if (self.mediaType == .video) { return self.videoView.player?.currentItem?.asset }
            return nil
        }
        set {
            if let asset = newValue {
                self.showVideoView()
                self.mediaType = .video
                self.videoSize = asset.naturalSize
                let item = AVPlayerItem(asset: asset)
                self.videoView.player?.replaceCurrentItem(with: item)
                switch self.videoPlaybackOption {
                case .autostart:
                    self.videoView.player?.play()
                case .previousPlaybackState:
                    switch previousVideoPlaybackState {
                    case .isPlaying:
                        self.videoView.player?.play()
                    default:
                        self.videoView.player?.pause()
                    }
                case .off:
                    self.videoView.player?.pause()
                }
                self.hideImageView()
            } else if (self.mediaType == .video) {
                self.hideVideoView()
                self.mediaURL = nil
                self.mediaType = nil
            }
        }
    }

    public var image: NSImage? {
        get {
            if (self.mediaType == .image || self.mediaType == .gif) { return self.imageView.image }
            return nil
        }
        set {
            if let image = newValue {
                self.showImageView()
                self.imageView.image = image
                self.hideVideoView()
                self.mediaType = .image
            } else if (self.mediaType == .image) {
                self.hideImageView()
                self.mediaURL = nil
                self.mediaType = nil
            }
        }
    }
    
    public var images: [NSImage] {
        get {return imageView.images}
        set {imageView.images = newValue
            if newValue.isEmpty == false {
                self.showImageView()
                self.hideVideoView()
                self.mediaType = .image
            } else if self.mediaType == .image {
                self.hideImageView()
                self.mediaURL = nil
                self.mediaType = nil
            }
        }
    }
    
    @available(macOS 12.0, iOS 13.0, *)
    public var symbolConfiguration: NSUIImage.SymbolConfiguration? {
        get { self.imageView.symbolConfiguration }
        set { self.imageView.symbolConfiguration = newValue }
    }
            
    public func play() {
        self.imageView.startAnimating()
        self.videoView.player?.play()
    }
    
    public func pause() {
        self.imageView.pauseAnimating()
        self.videoView.player?.pause()
        
    }
    
    public func stop() {
        self.imageView.stopAnimating()
        self.videoView.player?.stop()
    }
    
    public func togglePlayback() {
        self.imageView.toggleAnimating()
        self.videoView.player?.togglePlayback()
    }
    
    public var isPlaying: Bool {
        if (self.mediaType == .image || self.mediaType == .gif) {
            return imageView.isAnimating
        } else if (self.mediaType == .video) {
            return videoView.player?.state == .isPlaying
        }
        return false
    }
    
    public override var fittingSize: NSSize {
        if (self.mediaURL?.fileType == .image || self.mediaURL?.fileType == .gif) {
            return imageView.fittingSize
        } else if (self.mediaURL?.fileType == .video) {
            return videoView.fittingSize
        }
        return .zero
    }
    
    public func sizeToFit() {
        self.frame.size = self.fittingSize
    }
    
    private enum VideoPlaybackState {
        case playing
        case paused
        case stopped
    }
        
    private func showImageView() {
            self.imageView.frame = self.frame
            self.imageView.imageScaling = self.contentScaling
            self.imageView.isHidden = false
    }
    
    private func hideImageView() {
        self.imageView.image = nil
        self.imageView.isHidden = true
    }
    
    private func showVideoView() {
            self.updateVideoViewConfiguration()
            self.setupPlayerItemDidReachEnd()
            self.videoView.isHidden = false
    }
        
    private func hideVideoView() {
        self.updatePreviousPlaybackState()
        if let player = self.videoView.player {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
        self.videoView.player?.pause()
        self.videoView.player?.replaceCurrentItem(with: nil)
        self.videoView.isHidden = true
    }
    
    private var previousVideoPlaybackState: AVPlayer.State = .isStopped
    private var videoSize: CGSize? = nil
    
    private func updateVideoViewConfiguration() {
        self.videoView.player?.volume = self.volume
        self.videoView.controlsStyle = self.videoViewControlStyle
        self.videoView.videoGravity = AVLayerVideoGravity(caLayerContentsGravity: self.contentScaling) ?? .resizeAspectFill
        self.videoView.player?.isMuted = self.isMuted
    }
    
    private func updatePreviousPlaybackState() {
        if let player = self.videoView.player {
            self.previousVideoPlaybackState = player.state
        }
    }
    
    private func setupPlayerItemDidReachEnd() {
        if self.mediaURL?.fileType == .video, let player = self.videoView.player {
            player.actionAtItemEnd = .none
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReachEnd(notification:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
        }
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            if (self.loopVideos) {
                playerItem.seek(to: CMTime.zero, completionHandler: nil)
            }
        }
    }
    
    internal  lazy var imageView: ImageView = {
        let imageView = ImageView()
        imageView.imageScaling = self.contentScaling
        imageView.isHidden = true
        return imageView
    }()
    
    internal lazy var videoView: NoKeyDownPlayerView = {
        let videoView = NoKeyDownPlayerView()
        videoView.isHidden = true
        videoView.videoGravity = AVLayerVideoGravity(caLayerContentsGravity: self.contentScaling) ?? .resizeAspectFill
        return videoView
    }()
    
    public init(mediaURL: URL) {
        super.init(frame: .zero)
        self.mediaURL = mediaURL
    }
    
    public init(frame: CGRect, mediaURL: URL) {
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
        self.contentScaling = .resizeAspectFill
        self.addSubview(withConstraint: self.imageView)
        self.addSubview(withConstraint: self.videoView)

    }
}


internal class NoKeyDownPlayerView: AVPlayerView {
    var ignoreKeyDown = true
    override func keyDown(with event: NSEvent) {
        if (ignoreKeyDown) {
            self.nextResponder?.keyDown(with: event)
        } else {
            super.keyDown(with: event)
        }
    }
}

#endif
