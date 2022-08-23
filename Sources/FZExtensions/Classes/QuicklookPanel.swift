//
//  Quicklook.swift
//  FZCollection
//
//  Created by Florian Zand on 08.05.22.
//

#if os(macOS)

import Foundation
import Quartz
import AppKit

public protocol QLPreviewable {
    var url: URL {get}
    var frame: CGRect? {get}
}

public struct QuicklookItem: QLPreviewable {
    public let url: URL
    public var frame: CGRect?
    public init(_ url: URL, _ frame: CGRect? = nil) {
        self.url = url
        self.frame = frame
    }
    public init(url: URL, frame: CGRect? = nil) {
        self.url = url
        self.frame = frame
    }
}

public class QuicklookPanel: NSObject {
    public static let shared = QuicklookPanel()

    public weak var keyDownResponder: NSResponder? = nil
    
    public override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
        return true
    }
    
    public override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
        panel.dataSource = self
        panel.delegate = self
    }
    
    public override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
    //    panel.dataSource = self
    //    panel.delegate = self
    }
    
    public var previewPanel: QLPreviewPanel {
        QLPreviewPanel.shared()
    }
    
    public var isOpen: Bool {
        return previewPanel.isVisible
    }
        
   internal var items = [QLPreviewable]()
   
    public  func preview(_ items: [QLPreviewable]) {
        self.items = items
        previewPanel.reloadData()
        open()
    }
    
    public func preview(_ urls: [URL]) {
        self.items = urls.compactMap({QuicklookItem($0)})
        previewPanel.reloadData()
        open()
    }
  
    public  func open() {
        if (isOpen == false) {
            previewPanel.center()
            previewPanel.makeKeyAndOrderFront(nil)
        }
    }
    
    public func close(_ items: [QLPreviewable]? = nil) {
        if let items = items {
            self.items = items
        }
        previewPanel.orderOut(nil)
    }
    
    public  func toggleOpen() {
        if (previewPanel.isVisible) {
            close()
        } else {
            open()
        }
    }
    
    public override init() {
         super.init()
   //     self.beginPreviewPanelControl(self.previewPanel)
        previewPanel.delegate = self
        previewPanel.dataSource = self
    }
}

extension QuicklookPanel: QLPreviewPanelDataSource, QLPreviewPanelDelegate {
    public func previewPanel(_ panel: QLPreviewPanel!, handle event: NSEvent!) -> Bool {
        if(self.items.count > 1 && (event.keyCode == 123 || event.keyCode == 124)) {
            return true
        }
        if let keyDownResponder = keyDownResponder, (event.type == .keyDown ||  event.type == .keyUp), event.keyCode != 49 {
            if (event.type == .keyDown) {
            keyDownResponder.keyDown(with: event)
            }
            return true
        } else {
            return true
        }
    }
    
    public func previewPanel(_ panel: QLPreviewPanel!, sourceFrameOnScreenFor item: QLPreviewItem!) -> NSRect {
        return self.items.first(where: {$0.url == item.previewItemURL})?.frame ?? .zero
            }
    
    public func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        return self.items[index].url as QLPreviewItem
    }
    
    public func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return self.items.count
    }
}

#endif
