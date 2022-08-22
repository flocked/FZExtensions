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

protocol QLPreviewable {
    var url: URL {get}
    var frame: CGRect? {get}
}

struct QuicklookItem: QLPreviewable {
    var url: URL
    var frame: CGRect?
    init(_ url: URL, _ frame: CGRect? = nil) {
        self.url = url
        self.frame = frame
    }
    init(url: URL, frame: CGRect? = nil) {
        self.url = url
        self.frame = frame
    }
}

class QuicklookPanel: NSObject {
    static let shared = QuicklookPanel()

    weak var keyDownResponder: NSResponder? = nil
    
    override func acceptsPreviewPanelControl(_ panel: QLPreviewPanel!) -> Bool {
        return true
    }
    
    override func beginPreviewPanelControl(_ panel: QLPreviewPanel!) {
        panel.dataSource = self
        panel.delegate = self
    }
    
    override func endPreviewPanelControl(_ panel: QLPreviewPanel!) {
    //    panel.dataSource = self
    //    panel.delegate = self
    }
    
    var previewPanel: QLPreviewPanel {
        QLPreviewPanel.shared()
    }
    
    var isOpen: Bool {
        return previewPanel.isVisible
    }
        
   private var items = [QLPreviewable]()
   
    func preview(_ items: [QLPreviewable]) {
        self.items = items
        previewPanel.reloadData()
        open()
    }
    
    func preview(_ urls: [URL]) {
        self.items = urls.compactMap({QuicklookItem($0)})
        previewPanel.reloadData()
        open()
    }
  
    func open() {
        if (isOpen == false) {
            previewPanel.center()
            previewPanel.makeKeyAndOrderFront(nil)
        }
    }
    
    func close(_ items: [QLPreviewable]? = nil) {
        if let items = items {
            self.items = items
        }
        previewPanel.orderOut(nil)
    }
    
    func toggleOpen() {
        if (previewPanel.isVisible) {
            close()
        } else {
            open()
        }
    }
    
    override init() {
         super.init()
   //     self.beginPreviewPanelControl(self.previewPanel)
        previewPanel.delegate = self
        previewPanel.dataSource = self
    }
}

extension QuicklookPanel: QLPreviewPanelDataSource, QLPreviewPanelDelegate {
    func previewPanel(_ panel: QLPreviewPanel!, handle event: NSEvent!) -> Bool {
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
    
    func previewPanel(_ panel: QLPreviewPanel!, sourceFrameOnScreenFor item: QLPreviewItem!) -> NSRect {
        return self.items.first(where: {$0.url == item.previewItemURL})?.frame ?? .zero
            }
    
    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        return self.items[index].url as QLPreviewItem
    }
    
    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return self.items.count
    }
}

#endif
