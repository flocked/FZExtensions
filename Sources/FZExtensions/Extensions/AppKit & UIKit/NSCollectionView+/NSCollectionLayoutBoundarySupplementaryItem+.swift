//
//  File.swift
//  
//
//  Created by Florian Zand on 08.09.22.
//

#if os(macOS)
import AppKit

public extension NSCollectionLayoutBoundarySupplementaryItem {
     static func topSeperator(using properties: ContentProperties.Seperator) -> NSCollectionLayoutBoundarySupplementaryItem {
        let lineItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(properties.height))
        let item = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineItemSize, elementKind: NSCollectionView.elementKindItemTopSeperator, alignment: .top)
        item.contentInsets = properties.insets
        return item
    }
    
    static func bottomSeperator(using properties: ContentProperties.Seperator) -> NSCollectionLayoutBoundarySupplementaryItem {
        let lineItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(properties.height))
        let item = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineItemSize, elementKind: NSCollectionView.elementKindItemBottomSeperator, alignment: .bottom)
        item.contentInsets = properties.insets
        return item
    }
}
#endif
