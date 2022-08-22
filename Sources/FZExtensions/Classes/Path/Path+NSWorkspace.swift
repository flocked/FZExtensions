//
//  Path+Workspace.swift
//  FZExtensions
//
//  Created by Florian Zand on 06.06.22.
//

#if os(macOS)
import Foundation
import AppKit

public extension Pathish {
    func selectInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([self.url])
      }
      
     func open() {
          NSWorkspace.shared.open(url)
      }
}

public extension Array where Element == Path {
    func selectInFinder() {
        let urls = self.compactMap({$0.url})
        NSWorkspace.shared.activateFileViewerSelecting(urls)
    }
    func open() {
        for path in self {
            NSWorkspace.shared.open(path.url)
        }
    }
}
#endif
