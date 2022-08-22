//
//  URL+DirectoryIrator.swift
//  ImageViewer
//
//  Created by Florian Zand on 02.08.22.
//  Copyright © 2022 MuffinStory. All rights reserved.
//

import Foundation

extension URL : Sequence {
    
    public typealias DirectoryEnumerationOptions = FileManager.DirectoryEnumerationOptions
    public typealias DirectoryEnumerationMatch = DirectoryEnumerator.Match
    
    public struct URLSequence : Sequence {
        public typealias DirectoryEnumerationOptions = FileManager.DirectoryEnumerationOptions
        public typealias Match = DirectoryEnumerator.Match
        
        private var url: URL
        private var options: DirectoryEnumerationOptions
        private var match: Match
        
        init(url: URL, options: DirectoryEnumerationOptions, match: @escaping Match) {
            self.url = url
            self.options = options
            self.match = match
        }
        
        public func makeIterator() -> DirectoryEnumerator {
            return DirectoryEnumerator(url: url, options: options, match: match)
        }
    }

    public struct DirectoryEnumerator : IteratorProtocol {
        public typealias Element = URL
        public typealias Match = ((Self.Element) throws -> Bool)
        public typealias DirectoryEnumerationOptions = FileManager.DirectoryEnumerationOptions
        
        let url: URL
        let directoryEnumerator: FileManager.DirectoryEnumerator?
        let match: Match
        
        init(url: URL, options mask: DirectoryEnumerationOptions = [], match: @escaping Match = {url in return true}) {
            let options = FileManager.DirectoryEnumerationOptions(rawValue: mask.rawValue)
            self.url = url
            self.directoryEnumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil, options: options)

            self.match = match
        }
        
        public func next() -> URL? {
            

            let next = directoryEnumerator?.nextObject()

            if let next = next as? URL, (try? self.match(next)) == true {
                return next
            }
            return nil
        }
        
        /// Skip recursion into the most recently obtained subdirectory.
        public func skipDescendants() {
            directoryEnumerator?.skipDescendants()
        }
    }

    public func makeIterator() -> DirectoryEnumerator {
        return DirectoryEnumerator(url: self)
    }

    public func iterateSubdirectories(match: @escaping DirectoryEnumerationMatch = {url in return true}) -> URLSequence {
        return URLSequence(url: self, options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants], match: match)
    }
    
    
    public func iterateFiles(pathExtensions: [String], includeSubdirectoryDescendants: Bool = false) -> URLSequence {
        let options: DirectoryEnumerationOptions = (includeSubdirectoryDescendants == true) ? [.skipsHiddenFiles, .skipsPackageDescendants] : [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants]
        let pathExtensions = pathExtensions .map{$0.lowercased()}
        let checkPathExtensions = (pathExtensions.isEmpty == false)
        let match: DirectoryEnumerationMatch =  { url in
            let urlExtension = url.pathExtension.lowercased()
            if (checkPathExtensions) {
                return pathExtensions.contains(urlExtension)
            } else {
                return true
            }
        }
        return URLSequence(url: self, options: options, match: match)
    }
    
}
