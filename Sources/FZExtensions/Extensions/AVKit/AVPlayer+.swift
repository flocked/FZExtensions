//
//  AVPlayer+.swift
//  NewImageViewer
//
//  Created by Florian Zand on 07.08.22.
//

import Foundation
import AVKit

public extension AVPlayer {
    enum State: Int {
        case isPlaying
        case isPaused
        case isStopped
        case error
    }
    
    var state: State {
        if self.error != nil {
            return .error
        } else {
            if ((self.rate == 0) && self.currentTime() != .zero) {
                return .isPaused
            } else if (self.rate != 0) {
                return .isPlaying
            } else {
                return .isStopped
            }
        }
    }
        
    func stop() {
        self.pause()
        self.seek(to: .zero)
    }
    
    func togglePlayback() {
        if (self.state == .isPlaying) {
            self.pause()
        } else {
            self.play()
        }
    }
}

public extension AVLayerVideoGravity {
    init?(caLayerContentsGravity: CALayerContentsGravity) {
        switch caLayerContentsGravity {
        case .resizeAspectFill:
            self = .resizeAspectFill
        case .resizeAspect:
            self = .resizeAspect
        case .resize:
            self = .resize
        default:
            return nil
        }
    }
}
