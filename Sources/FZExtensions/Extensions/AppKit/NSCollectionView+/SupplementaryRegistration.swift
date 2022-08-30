//
//  SupRegi.swift
//  FZCollection
//
//  Created by Florian Zand on 19.05.22.
//

#if os(macOS)

import Foundation
import AppKit

public protocol NSCollectionViewSupplementaryProvider {
        func makeSupplementaryView(_ collectionView: NSCollectionView, _ indexPath: IndexPath) -> (NSView & NSCollectionViewElement)
        var elementKind: String { get }
}

public extension NSCollectionView {
    class SupplementaryRegistration<Supplementary>: NSCollectionViewSupplementaryProvider where Supplementary: (NSView & NSCollectionViewElement)  {
        
        typealias Handler = ((Supplementary, SupplementaryElementKind, IndexPath)->(Void))
        
        private let identifier: NSUserInterfaceItemIdentifier
        private let nib: NSNib?
        private let handler: Handler
        public let elementKind: SupplementaryElementKind
        private weak var registeredCollectionView: NSCollectionView? = nil
        
        init(elementKind: SupplementaryElementKind, handler: @escaping Handler) {
            self.handler = handler
            self.elementKind = elementKind
            self.nib = nil
            self.identifier = NSUserInterfaceItemIdentifier(String(describing: Supplementary.self) + elementKind)
        }
        
        init(nib: NSNib, elementKind: SupplementaryElementKind, handler: @escaping Handler) {
            self.nib = nib
            self.elementKind = elementKind
            self.handler = handler
            self.identifier = NSUserInterfaceItemIdentifier(String(describing: Supplementary.self) + elementKind)
        }
        
        public func makeSupplementaryView(_ collectionView: NSCollectionView, _ indexPath: IndexPath) -> (NSView & NSCollectionViewElement) {
            if (registeredCollectionView != collectionView) {
                self.register(for: collectionView)
            }
            let view: Supplementary = collectionView.makeSupplementaryView(ofKind: self.elementKind, withIdentifier: self.identifier, for: indexPath)
            self.handler(view, elementKind, indexPath)
            return view
        }
        
        fileprivate func register(for collectionView: NSCollectionView) {
            if let nib = self.nib {
                //     collectionView.reg
                collectionView.register(nib, forSupplementaryViewOfKind: self.elementKind, withIdentifier: self.identifier)
            } else {
                collectionView.register(Supplementary.self, forSupplementaryViewOfKind: self.elementKind, withIdentifier: self.identifier)
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
     func makeSupplementaryView<V>(using registration: SupplementaryRegistration<V>, for indexPath: IndexPath) -> V {
        return registration.makeSupplementaryView(self, indexPath) as! V
    }
}

public extension NSCollectionView {
    func register<V>(_ viewClass: V.Type, forSupplementaryViewOfKind kind: NSCollectionView.SupplementaryElementKind) where V: (NSView & NSCollectionViewElement) {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: V.self) + kind)
        self.register(V.self, forSupplementaryViewOfKind: kind, withIdentifier: identifier)
    }
    
    func makeSupplementaryView<V>(ofKind elementKind: NSCollectionView.SupplementaryElementKind, _ viewClass: V.Type, for indexPath: IndexPath) -> V where V: (NSView & NSCollectionViewElement) {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: V.self) + elementKind)
        return self.makeSupplementaryView(ofKind: elementKind, withIdentifier: identifier, for: indexPath)
    }
    
    func makeSupplementaryView<V>(ofKind elementKind: NSCollectionView.SupplementaryElementKind, withIdentifier identifier: NSUserInterfaceItemIdentifier, for indexPath: IndexPath) -> V where V: (NSView & NSCollectionViewElement) {
        let view = self.makeSupplementaryView(ofKind: elementKind, withIdentifier: identifier, for: indexPath)
        return view as! V
    }
}

#endif
