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
         let item = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineItemSize, elementKind: NSCollectionView.ElementKind.itemTopSeperator, alignment: .top)
        item.contentInsets = properties.insets
        return item
    }
    
    static func bottomSeperator(using properties: ContentProperties.Seperator) -> NSCollectionLayoutBoundarySupplementaryItem {
        let lineItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(properties.height))
        let item = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineItemSize, elementKind: NSCollectionView.ElementKind.itemBottomSeperator, alignment: .bottom)
        item.contentInsets = properties.insets
        return item
    }
    
    static func sectionHeader(height: NSCollectionLayoutDimension = .estimated(44), floating: Bool = false) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: height)
        let item = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSize,
            elementKind:  NSCollectionView.ElementKind.sectionHeader, alignment: .top)
        
        item.zIndex = .max
        item.pinToVisibleBounds = floating
        return item
   }
    
    static func sectionFooter(height: NSCollectionLayoutDimension = .estimated(44), floating: Bool = false) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: height)
        let item = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSize,
            elementKind:  NSCollectionView.ElementKind.sectionFooter, alignment: .bottom)
        
        item.zIndex = .max
        item.pinToVisibleBounds = floating
        return item
   }
    
    static func sectionBackground() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)),
                                                        elementKind: NSCollectionView.ElementKind.sectionBackground,
                                                        containerAnchor: .init(edges: .all))
   }
    
    static func itemBackground() -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)),
                                                        elementKind: NSCollectionView.ElementKind.itemBackground,
                                                        containerAnchor: .init(edges: .all))
   }
}
#endif
