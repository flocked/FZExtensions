//
//  MetadataQuery.swift
//  TabManagerTest
//
//  Created by Florian Zand on 23.08.22.
//

import Foundation

public class MetadataQuery: NSObject, NSMetadataQueryDelegate {
    public typealias CompletionHandler = (([URL])->())
    internal let query = NSMetadataQuery()
    internal var completionHandler: CompletionHandler? = nil
    
    func queryAttributes(_ attributes: [String], for urls: [URL], completion: @escaping CompletionHandler) {
        self.stop()
        self.addObserver()
        self.attributes = attributes
        self.urls = urls
        completionHandler = completion
        query.start()
    }
    
    func queryPixelSizes(for urls: [URL], completion: @escaping CompletionHandler) {
        self.stop()
        self.addObserver()
        self.attributes = [NSMetadataItemPixelHeightKey, NSMetadataItemPixelWidthKey]
        self.urls = urls
        completionHandler = completion
        query.start()
    }
    
    func stop() {
        self.removeObserver()
        query.stop()
    }
    
    internal var urls: [URL] {
        get { if let nsURLs = query.searchItems as? [NSURL] {
            return nsURLs as [URL] }
            return [] }
        set { query.searchItems = newValue as [NSURL]  }
    }
    
    internal var attributes: [String] {
        get { return query.valueListAttributes }
        set { return query.valueListAttributes = newValue }
    }
    
    @objc internal func didStartGathering(notification: Notification) {
        Swift.print("Did didStartGathering")
    }
    
    @objc internal func didUpdate(notification: Notification) {
        Swift.print("MetadataQuery Updated")
    }
    
    @objc internal func didFinish(notification: Notification) {
        self.removeObserver()
        Swift.print("MetadataQuery End")
        query.stop()
        var newFiles = [URL]()
        for (_, result) in query.results.enumerated() {
            if let item = result as? NSMetadataItem, let path = item.value(forAttribute: NSMetadataItemPathKey) as? String {
                let url = URL(fileURLWithPath: path)
                newFiles.append(url)
                /*
                 if let width = query.value(ofAttribute: NSMetadataItemPixelWidthKey,
                 forResultAt: index) as? Double, let height = query.value(ofAttribute: NSMetadataItemPixelHeightKey, forResultAt: index) as? Double {
                 let size = CGSize(width: width, height: height)
                 let newFile = AdvancedFile(url: url, size: size)
                 newFile.finishedLoadingMediaSize = true
                 newFiles.append(newFile)
                 } else {
                 }
                 */
            } }
        completionHandler?(newFiles)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didStartGathering(notification:)), name:   NSNotification.Name.NSMetadataQueryDidFinishGathering , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(notification:)), name:   NSNotification.Name.NSMetadataQueryDidUpdate , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinish(notification:)), name:   NSNotification.Name.NSMetadataQueryDidFinishGathering , object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    override init() {
        super.init()
        query.operationQueue = .main
        query.predicate =  NSPredicate(format: "%K like '*.*'", NSMetadataItemFSNameKey)
        query.searchScopes = [NSMetadataQueryLocalComputerScope]
    }
}
