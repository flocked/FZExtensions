//
//  File.swift
//  
//
//  Created by Florian Zand on 22.08.22.
//

import Foundation

public extension URL {
     enum FileType: String, CaseIterable {
         case image
         case video
         case gif
         case audio
        case diretory
        public init?(rawValue: String) {
             switch rawValue {
             case Self.image.rawValue:
                 self = .image
             case Self.video.rawValue:
                 self = .video
             case Self.gif.rawValue:
                 self = .gif
             case Self.audio.rawValue:
                 self = .audio
             case Self.diretory.rawValue:
                 self = .diretory
             default:
                 return nil
             }
         }
         
         init?(url: URL) {
             switch url.pathExtension.lowercased() {
             case let pathExtension where Self.image.pathExtensions.contains(pathExtension):
                 self = .image
             case let pathExtension where Self.video.pathExtensions.contains(pathExtension):
                 self = .video
             case let pathExtension where Self.gif.pathExtensions.contains(pathExtension):
                 self = .gif
             case let pathExtension where Self.audio.pathExtensions.contains(pathExtension):
                 self = .audio
             default:
                 return nil
             }
         }
         
         init?(pathExtension: String) {
             switch pathExtension.lowercased() {
             case let pExt where Self.image.pathExtensions.contains(pExt):
                 self = .image
             case let pExt where Self.video.pathExtensions.contains(pExt):
                 self = .video
             case let pExt where Self.gif.pathExtensions.contains(pExt):
                 self = .gif
             case let pExt where Self.audio.pathExtensions.contains(pExt):
                 self = .audio
             default:
                 return nil
             }
         }
         
        static var multimediaTypes: [FileType] = [.gif, .image, .video]
        static var imageTypes: [FileType] = [.gif, .image]

        var isMultimedia: Bool {
            return FileType.multimediaTypes.contains(self)
        }
         
         var pathExtensions: [String] {
             switch self {
             case .image:
                 return ["png", "gif", "jpeg", "jpg", "heic", "tiff", "tif", "heif", "pnj"]
             case .video:
                return ["m4v", "mov", "mp4", "ts", "avi", "mpeg", "qt", "gifv"]
             case .gif:
                return ["gif"]
             case .audio:
                 return ["mp3", "wav", "wave", "flac", "ogg", "alac", "m4a", "aiff"]
             case .diretory:
                return []
             }
         }
     }
     
     var fileType: FileType? {
         return FileType.init(pathExtension: self.pathExtension)
     }
    
    var isVideo: Bool {
        self.fileType == .video
    }
    
    var isImage: Bool {
        self.fileType == .image
    }
    
    var isGIF: Bool {
        self.fileType == .gif
    }
    
    var isMultimedia: Bool {
        self.fileType?.isMultimedia ?? false
    }
    
}
