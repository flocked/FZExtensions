//
//  CellRegestration.swift
//  FZCollection
//
//  Created by Florian Zand on 27.04.22.
//

#if os(macOS)

import Foundation
import AppKit

extension NSCollectionViewDiffableDataSource {
    convenience init<I: NSCollectionViewItem>(collectionView: NSCollectionView, itemRegistration: NSCollectionView.ItemRegistration<I, ItemIdentifierType>) {
        self.init(collectionView: collectionView, itemProvider:  {
            tCollectionView, indexPath, element in
            return  tCollectionView.makeItem(using: itemRegistration, for: indexPath, element: element)
        })
    }
    
    convenience init<I: NSCollectionViewItem>(collectionView: NSCollectionView, itemRegistration: NSCollectionView.ItemRegistration<I, ItemIdentifierType>, supplementaryRegistrations: [NSCollectionViewSupplementaryProvider]) {
        self.init(collectionView: collectionView, itemRegistration: itemRegistration)
        self.supplementaryViewProvider(using: supplementaryRegistrations)
    }
    
    func supplementaryViewProvider(using providers: [NSCollectionViewSupplementaryProvider]) {
        self.supplementaryViewProvider = { tCollectionView, kind, indexPath in
            if let provider =  providers.first(where: {$0.elementKind == kind}) {
                return provider.makeSupplementaryView(tCollectionView, indexPath)
            }
            return nil
        }
    }
}

public extension NSCollectionView {
    class ItemRegistration<Item, Element> where Item: NSCollectionViewItem  {
        
        typealias Handler = ((Item, IndexPath, Element)->(Void))
        
        private let identifier: NSUserInterfaceItemIdentifier
        private let nib: NSNib?
        private let handler: Handler
        private weak var registeredCollectionView: NSCollectionView? = nil
        
        init(handler: @escaping Handler) {
            self.handler = handler
            self.nib = nil
            self.identifier = NSUserInterfaceItemIdentifier(String(describing: Item.self))
        }
        
        init(nib: NSNib, handler: @escaping Handler) {
            self.nib = nib
            self.identifier = NSUserInterfaceItemIdentifier(String(describing: Item.self))
            self.handler = handler
        }
        
        fileprivate func makeItem(_ collectionView: NSCollectionView, _ indexPath: IndexPath, _ element: Element) -> Item {
            if (registeredCollectionView != collectionView) {
                self.register(for: collectionView)
            }
            let item: Item
            if let existingItem = collectionView.item(at: indexPath) as? Item {
                item = existingItem
            } else {
                item = collectionView.makeItem(withIdentifier: self.identifier, for: indexPath) as! Item
            }
            self.handler(item, indexPath, element)
            return item
        }
        
        fileprivate func register(for collectionView: NSCollectionView) {
            if let nib = self.nib {
                collectionView.register(nib, forItemWithIdentifier: self.identifier)
            } else {
                collectionView.register(Item.self, forItemWithIdentifier: self.identifier)
            }
            self.registeredCollectionView = collectionView
        }
        
        fileprivate func unregister(for collectionView: NSCollectionView) {
            let any: AnyClass? = nil
            collectionView.register(any, forItemWithIdentifier: self.identifier)
            self.registeredCollectionView = nil
        }
        
        deinit {
            if let registeredCollectionView = registeredCollectionView {
                self.unregister(for: registeredCollectionView)
            }
        }
    }
    
    func makeItem<I: NSCollectionViewItem, E: Any>(using itemRegistration: ItemRegistration<I, E>, for indexPath: IndexPath, element: E) -> I {
        return itemRegistration.makeItem(self, indexPath, element)
    }
}

#endif
