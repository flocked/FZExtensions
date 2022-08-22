//
//  CollectionView+.swift
//  CellTest
//
//  Created by Florian Zand on 18.05.22.
//

#if os(macOS)

import Foundation
import AppKit

extension NSCollectionView {
    func register<V: NSCollectionViewItem>(_ item: V.Type) {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: V.self))
        self.register(V.self, forItemWithIdentifier: identifier)
    }
    
    func makeItem<V: NSCollectionViewItem>(_ ty: V.Type, for indexPath: IndexPath) -> V {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: V.self))
        return self.makeItem(V.self, withIdentifier: identifier, for: indexPath)
    }
    
    func makeItem<V: NSCollectionViewItem>(for indexPath: IndexPath) -> V {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: V.self))
        return self.makeItem(V.self, withIdentifier: identifier, for: indexPath)
    }
    
    func makeItem<V: NSCollectionViewItem>(_ ty: V.Type, withIdentifier identifier: NSUserInterfaceItemIdentifier, for indexPath: IndexPath) -> V {
        if let item = self.item(at: indexPath) as? V {
            return item
        }
         let item = self.makeItem(withIdentifier: identifier, for: indexPath)
        return item as! V
    }
    
    func reconfigurateItems(at indexPaths: [IndexPath]) {
        let visibleIndexPaths = self.indexPathsForVisibleItems()
        for indexPath in indexPaths {
            if (visibleIndexPaths.contains(indexPath)) {
                self.dataSource?.collectionView(self, itemForRepresentedObjectAt: indexPath)
            }
        }
    }
}

#endif
