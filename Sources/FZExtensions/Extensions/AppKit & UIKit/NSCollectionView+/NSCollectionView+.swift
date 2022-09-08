//
//  NSCollectionView+.swift
//  FZExtensions
//
//  Created by Florian Zand on 06.06.22.
//

#if os(macOS)

import Foundation
import AppKit

public extension NSCollectionView {
    static let elementKindItemTopSeperator: String = "ElementKindItemTopSeperator"
    static let elementKindItemBottomSeperator: String = "ElementKindBottomSeperator"
    
    func displayingIndexPaths() -> [IndexPath] {
        return self.displayingItems().compactMap({self.indexPath(for: $0)}).sorted()
    }
    
    func displayingItems() -> [NSCollectionViewItem] {
        let visibleItems = self.visibleItems()
        let visibleRect = self.visibleRect
       return visibleItems.filter({NSIntersectsRect($0.view.frame, visibleRect)})
    }
    
    func frameForItem(at indexPath: IndexPath) -> CGRect? {
       return self.layoutAttributesForItem(at: indexPath)?.frame
    }
    
    func indexPaths(for section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        if (numberOfSections > section) {
            let numberOfItems = self.numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                indexPaths.append(IndexPath(item: item, section: section))
                }
            }
        return indexPaths
    }
    
    var allIndexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        for section in 0..<self.numberOfSections {
            indexPaths.append(contentsOf: self.indexPaths(for: section))
        }
        return indexPaths
    }
    
    var notSelectedIndexPaths: [IndexPath] {
        let selected = self.selectionIndexPaths
        return self.allIndexPaths.filter({selected.contains($0) == false})
    }
    
    func scrollToTop() {
        self.enclosingScrollView?.scrollToBeginningOfDocument(nil)
    }
    
    func scrollToBottom() {
        self.enclosingScrollView?.scrollToEndOfDocument(nil)
    }
        
    func setLayout(_ layout: NSCollectionViewLayout, animated: Bool, duration: CGFloat) {
        if (animated) {
            CATransaction.perform(animated: true, duration: duration, animations: {
                self.animator().collectionViewLayout = layout
            }, completinonHandler: nil)
        } else {
            self.collectionViewLayout = layout
        }
    }
        
    var contentOffset: CGPoint {
      get { return enclosingScrollView?.documentVisibleRect.origin ?? .zero }
      set { scroll(newValue) }
    }
    
    var contentSize: CGSize {
        get { return enclosingScrollView?.contentSize ?? .zero }
    }
}

public extension NSCollectionView {
        struct SavedScrollPosition {
            let bounds: CGRect
            let visible: CGRect
        }
    
        func saveScrollPosition() -> SavedScrollPosition {
            return SavedScrollPosition(bounds: bounds, visible: visibleRect)
        }

        func restoreScrollPosition(_ saved: SavedScrollPosition) {
            let oldBounds = saved.bounds
            let oldVisible = saved.visible
            let oldY = oldVisible.midY
            let oldH = oldBounds.height
            guard oldH > 0.0 else { return }

            let fraction = (oldY - oldBounds.minY) / oldH
            let newBounds = self.bounds
            var newVisible = self.visibleRect
            let newY = newBounds.minY + fraction * newBounds.height
            newVisible.origin.y = newY - 0.5 * newVisible.height
            self.scroll(newVisible.origin)
        }
}

#endif
