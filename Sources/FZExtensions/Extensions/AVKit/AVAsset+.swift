//
//  AVAsset+.swift
//  NewImageViewer
//
//  Created by Florian Zand on 07.08.22.
//

import Foundation
import AVFoundation

extension AVAsset {
    var naturalSize: CGSize? {
        guard let track = self.tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
            return CGSize(width: abs(size.width), height: abs(size.height))
        }
}
