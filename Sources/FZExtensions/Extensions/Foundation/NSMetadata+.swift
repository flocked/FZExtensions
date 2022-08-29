//
//  File.swift
//  
//
//  Created by Florian Zand on 28.08.22.
//

import Foundation

extension NSMetadataItem {
    public func value<T>(_ attribute: String, type: T.Type) -> T? {
        return self.value(forAttribute: attribute) as? T
    }
}

extension NSMetadataQuery {
    public func values(of attributes: [String], forResultsAt index: Int) -> [String: Any] {
        var values = [String: Any]()
        attributes.forEach({ values[$0] = value(ofAttribute: $0, forResultAt: index) })
        return values
    }
}
