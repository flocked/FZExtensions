//
//  MetadataQuery.swift
//  TabManagerTest
//
//  Created by Florian Zand on 23.08.22.
//

import Foundation


public class MetadataQuery: NSObject, NSMetadataQueryDelegate {
    public typealias Handler = (([MetadataItem])->())
    internal let query = NSMetadataQuery()
    public var completionHandler: Handler? = nil
    public var updateHandler: Handler? = nil
    
    func query(attributes: [String], for urls: [URL]) {
        self.stop()
        self.attributes = attributes
        self.urls = urls
        self.start()
    }
    
    public func start() {
        if (isStopped) {
            self.addObserver()
            query.start()
        }
    }
    
    public func stop() {
        self.removeObserver()
        query.stop()
    }
    
    public var urls: [URL] {
        get { (self.query.searchItems as? [URL]) ?? [] }
        set { query.searchItems = newValue as [NSURL]  } }
    
    internal var attributes: [String] {
        get { return query.valueListAttributes }
        set { return query.valueListAttributes = newValue }
    }
    
    public var results: [MetadataItem] {
        return self.query.itemResults()
    }
    
    @objc internal func didStartGathering(notification: Notification) {
        Swift.print("Did didStartGathering")
    }
    
    @objc internal func didUpdate(notification: Notification) {
        Swift.print("MetadataQuery Updated")
    }
    
    @objc internal func didFinish(notification: Notification) {
        self.removeObserver()
        query.stop()
        completionHandler?(self.results)
    }
        
    public var isStarted: Bool { return self.query.isStarted }
    public var isGathering: Bool { return self.query.isGathering }
    public var isStopped: Bool { return self.query.isStopped }
    
    public var operationQueue: OperationQueue? {
        get { self.query.operationQueue }
        set { self.query.operationQueue = newValue } }
    
    public var predicate: NSPredicate? {
        get { self.query.predicate }
        set { self.query.predicate = newValue } }
    
    public var updateNotificationInteral: TimeInterval {
        get { self.query.notificationBatchingInterval }
        set { self.query.notificationBatchingInterval = newValue } }
    
    
    public var sortedBy: [SortOption] = [SortOption(.displayName, ascending: true)]
 
    public var sortDescriptors: [NSSortDescriptor] {
        get { self.query.sortDescriptors }
        set { self.query.sortDescriptors = newValue } }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didStartGathering(notification:)), name:   NSNotification.Name.NSMetadataQueryDidFinishGathering , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(notification:)), name:   NSNotification.Name.NSMetadataQueryDidUpdate , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinish(notification:)), name:   NSNotification.Name.NSMetadataQueryDidFinishGathering , object: nil)
    }
    
    internal func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override init() {
        super.init()
        self.operationQueue = .main
    //    self.query.searchItems
        self.predicate =  NSPredicate(format: "%K like '*.*'", NSMetadataItemFSNameKey)
        query.searchScopes = [NSMetadataQueryLocalComputerScope]
    }
}

extension NSMetadataQuery {
    public func itemResults() -> [MetadataItem] {
        var items = [MetadataItem]()
        for (index, result) in self.results.enumerated() {
            let values = self.values(of: self.valueListAttributes, forResultsAt: index)
            if let metadataItem = result as? NSMetadataItem {
                items.append(MetadataItem(item: metadataItem, values: values))
            } else if let path = result as? String, let item = MetadataItem(url: URL(fileURLWithPath: path), values: values) {
                items.append(item)
            } else if let url = result as? URL, let item = MetadataItem(url: url, values: values) {
                items.append(item)
            }
        }
        return items
    }
}

