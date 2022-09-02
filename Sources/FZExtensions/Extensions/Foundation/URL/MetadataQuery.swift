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
    
    public var searchScopes: [SearchScope] {
        get { return query.searchScopes.compactMap({ if let value = $0 as? String {
            return SearchScope(rawValue: value)
        } else { return nil }  }) }
        set {  query.searchScopes = newValue.compactMap({$0.rawValue}) } }
    
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
#if os(macOS)
self.searchScopes = [.local]
#elseif canImport(UIKit)
self.searchScopes = [.ubiquitousDocuments]
#endif
        self.predicate =  NSPredicate(format: "%K like '*.*'", NSMetadataItemFSNameKey)
        query.searchScopes = [NSMetadataQueryLocalComputerScope]
    }
}

extension MetadataQuery {
#if os(macOS)
    public enum SearchScope: String {
        case home
        case local
        case localIndexed
        case network
        case networkIndexed
        case ubiquitousDocuments
        case ubiquitousData
        case accessibleUbiquitousExternalDocuments
        public var rawValue: String {
            switch self {
            case .home:  return NSMetadataQueryUserHomeScope
            case .local:  return NSMetadataQueryLocalComputerScope
            case .localIndexed:   return NSMetadataQueryIndexedLocalComputerScope
            case .network:  return NSMetadataQueryNetworkScope
            case .networkIndexed:  return NSMetadataQueryIndexedNetworkScope
            case .ubiquitousDocuments:   return NSMetadataQueryUbiquitousDocumentsScope
            case .ubiquitousData:  return NSMetadataQueryUbiquitousDataScope
            case .accessibleUbiquitousExternalDocuments: return NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope
            }
        }
    }
#elseif canImport(UIKit)
    public enum SearchScope: String {
        case ubiquitousDocuments
        case ubiquitousData
        case accessibleUbiquitousExternalDocuments
        public var rawValue: String {
            switch self {
            case .ubiquitousDocuments:   return NSMetadataQueryUbiquitousDocumentsScope
            case .ubiquitousData:  return NSMetadataQueryUbiquitousDataScope
            case .accessibleUbiquitousExternalDocuments: return NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope
            }
        }
    }
    #endif
}

extension NSMetadataQuery {
    #if os(macOS)
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
    #elseif canImport(UIKit)
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
    #endif
}


/*
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
     
     public override init() {
         super.init()
         query.operationQueue = .main
         self.predicate = NSPredicate(format: "%K like '*.*'", NSMetadataItemFSNameKey)
         #if os(macOS)
         self.searchScopes = [.local]
         #elseif canImport(UIKit)
         self.searchScopes = [.ubiquitousDocuments]
         #endif
         self.addObserver()
     }
     
     public func queryAttributes(_ attributes: [String], for urls: [URL]) {
         self.query.stop()
         query.searchItems = urls as [NSURL]
         query.valueListAttributes = attributes
 #if os(macOS)
 self.searchScopes = [.local]
 #elseif canImport(UIKit)
 self.searchScopes = [.ubiquitousDocuments]
 #endif
         query.operationQueue?.addOperation {
             self.query.start()
         }
     }
         
     public func start() {
         self.addObserver()
         query.start()
     }
     
     public func stop() {
         self.removeObserver()
         query.stop()
     }
     
     public var updateHandler: Handler? = nil
     public var completionHandler: Handler? = nil

     public var updateNotificationInterval: TimeInterval {
         get { return query.notificationBatchingInterval }
         set {  query.notificationBatchingInterval = newValue } }
     
     public var isStarted: Bool { return query.isStarted }
     public var isGathering: Bool { return query.isGathering }
     public var isStopped: Bool { return query.isStopped }

     public  var urls: [URL] {
         get { if let nsURLs = query.searchItems as? [NSURL] {
                 return nsURLs as [URL] }
                 return [] }
         set { query.searchItems = newValue as [NSURL]  }
     }
     
     var sortDescriptors: [NSSortDescriptor] {
         get { return query.sortDescriptors }
         set {  query.sortDescriptors = newValue } }
     
  //   var sortedBy: [PartialKeyPath<MetadataItem>] = [\.displayName]

     public var attributes: [String] {
         get { return query.valueListAttributes }
         set {  query.valueListAttributes = newValue } }
     
     public var predicate: NSPredicate? {
         get { return query.predicate }
         set {  query.predicate = newValue } }
     
     public var operationQueue: OperationQueue? {
         get { return query.operationQueue }
         set {  query.operationQueue = newValue } }
     
     public var searchScopes: [SearchScope] {
         get { return query.searchScopes.compactMap({ if let value = $0 as? String {
             return SearchScope(rawValue: value)
         } else { return nil }  }) }
         set {  query.searchScopes = newValue.compactMap({$0.rawValue}) } }
     
     private func addObserver() {
         NotificationCenter.default.addObserver(self, selector: #selector(didStartGathering(notification:)), name:   NSNotification.Name.NSMetadataQueryDidFinishGathering , object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(notification:)), name:   NSNotification.Name.NSMetadataQueryDidUpdate , object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(didFinish(notification:)), name:   NSNotification.Name.NSMetadataQueryDidFinishGathering , object: nil)
     }
     
     private func removeObserver() {
         NotificationCenter.default.removeObserver(self)
     }
     
     @objc internal func didStartGathering(notification: Notification) {
         Swift.print("Did didStartGathering")
     }
     
     @objc internal func didUpdate(notification: Notification) {
         Swift.print("MetadataQuery Updated")
     }
     
     @objc internal func didFinish(notification: Notification) {
         Swift.print("MetadataQuery End")
         self.stop()
         completionHandler?(self.query.itemResults())
         var newFiles = [MediaFile]()
         for (index, result) in query.results.enumerated() {
             if let item = result as? NSMetadataItem, let path = item.value(forAttribute: NSMetadataItemPathKey) as? String {
                 let url = URL(fileURLWithPath: path)
                 if let width = query.value(ofAttribute: NSMetadataItemPixelWidthKey,
                                            forResultAt: index) as? Double, let height = query.value(ofAttribute: NSMetadataItemPixelHeightKey, forResultAt: index) as? Double {
                     let size = CGSize(width: width, height: height)
                     let newFile = MediaFile(url: url, size: size)
                     newFiles.append(newFile)
                 } else {
               } } }
         mediaFileCompletionHandler?(newFiles)
     }
 }

 extension MetadataQuery {
 #if os(macOS)
     public enum SearchScope: String {
         case home
         case local
         case localIndexed
         case network
         case networkIndexed
         case ubiquitousDocuments
         case ubiquitousData
         case accessibleUbiquitousExternalDocuments
         public var rawValue: String {
             switch self {
             case .home:  return NSMetadataQueryUserHomeScope
             case .local:  return NSMetadataQueryLocalComputerScope
             case .localIndexed:   return NSMetadataQueryIndexedLocalComputerScope
             case .network:  return NSMetadataQueryNetworkScope
             case .networkIndexed:  return NSMetadataQueryIndexedNetworkScope
             case .ubiquitousDocuments:   return NSMetadataQueryUbiquitousDocumentsScope
             case .ubiquitousData:  return NSMetadataQueryUbiquitousDataScope
             case .accessibleUbiquitousExternalDocuments: return NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope
             }
         }
     }
 #elseif canImport(UIKit)
     public enum SearchScope: String {
         case ubiquitousDocuments
         case ubiquitousData
         case accessibleUbiquitousExternalDocuments
         public var rawValue: String {
             switch self {
             case .ubiquitousDocuments:   return NSMetadataQueryUbiquitousDocumentsScope
             case .ubiquitousData:  return NSMetadataQueryUbiquitousDataScope
             case .accessibleUbiquitousExternalDocuments: return NSMetadataQueryAccessibleUbiquitousExternalDocumentsScope
             }
         }
     }
     #endif
 }

 extension NSMetadataQuery {
     #if os(macOS)
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
     #elseif canImport(UIKit)
     public func itemResults() -> [MetadataItem] {
         var items = [MetadataItem]()
         for (index, result) in self.results.enumerated() {
             let values = self.values(of: self.valueListAttributes, forResultsAt: index)
             if let metadataItem = result as? NSMetadataItem {
                 items.append(MetadataItem(item: metadataItem, values: values))
             }
         }
         return items
     }
     #endif
 }

 */
