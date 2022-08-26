//
//  NSUICollectionViewLayout+Waterfall.swift
//  PinterestSwift
//
//  Created by Nicholas Tau on 6/30/14.
//  Copyright (c) 2014 Nicholas Tau. All rights reserved.
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

public protocol NSCollectionViewWaterfallLayoutDelegate: NSUICollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    
    // Optional
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        heightForHeaderIn section: Int) -> CGFloat
    
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        heightForFooterIn section: Int) -> CGFloat
    
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        insetsFor section: Int) -> NSEdgeInsets
    
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        minimumInteritemSpacingFor section: Int) -> CGFloat
    
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        columnCountFor section: Int) -> Int
}

public extension NSCollectionViewWaterfallLayoutDelegate {
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        heightForHeaderIn section: Int) -> CGFloat {
        return -1 }
    
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        heightForFooterIn section: Int) -> CGFloat {
        return -1 }
    
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        insetsFor section: Int) -> NSEdgeInsets{
        return NSEdgeInsets(top: -1, left: -1, bottom: -1, right: -1) }
    
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        minimumInteritemSpacingFor section: Int) -> CGFloat {
        return -1 }
    
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSUICollectionViewLayout,
                        columnCountFor section: Int) -> Int {
        return -1 }
}


extension NSUICollectionViewLayout.WaterfallLayout {
    public enum ItemRenderDirection: Int {
        case shortestFirst
        case leftToRight
        case rightToLeft
    }
    
    public enum SectionInsetReference {
        case fromContentInset
        @available(macOS 11, *)
        case fromSafeArea
    }
}

extension NSUICollectionViewLayout {
public class WaterfallLayout: NSUICollectionViewLayout {
    public var columnCount: Int = 2 {
        didSet { invalidateLayout(animated: animationDuration ?? 0.0) } }
            
    public var minimumColumnSpacing: CGFloat = 10 {
        didSet { invalidateLayout() } }
    
    public var minimumInteritemSpacing: CGFloat = 10 {
        didSet { invalidateLayout() } }
    
    public var headerHeight: CGFloat = 0 {
        didSet { invalidateLayout() } }

    public var footerHeight: CGFloat = 0 {
        didSet { invalidateLayout() } }

    public var sectionInset: NSEdgeInsets = NSEdgeInsetsZero {
        didSet { invalidateLayout() } }
    
    public var itemRenderDirection: ItemRenderDirection = .shortestFirst {
        didSet { invalidateLayout() } }

    public var sectionInsetReference: SectionInsetReference = .fromContentInset {
        didSet { invalidateLayout() } }
    
    public var delegate: NSCollectionViewWaterfallLayoutDelegate? {
        get { return collectionView!.delegate as? NSCollectionViewWaterfallLayoutDelegate } }
    
    public var animationDuration: TimeInterval? = nil
    
    private var columnHeights: [[CGFloat]] = []
    private var sectionItemAttributes: [[NSUICollectionViewLayoutAttributes]] = []
    private var allItemAttributes: [NSUICollectionViewLayoutAttributes] = []
    private var headersAttributes: [Int: NSUICollectionViewLayoutAttributes] = [:]
    private var footersAttributes: [Int: NSUICollectionViewLayoutAttributes] = [:]
    private var unionRects: [CGRect] = []
    private let unionSize = 20
    
    private func columnCount(forSection section: Int) -> Int {
        var cCount = delegate?.collectionView(collectionView!, layout: self, columnCountFor: section) ?? columnCount
        if (cCount == -1) {
            cCount = self.columnCount
        }
        return cCount
    }
    
    private var collectionViewContentWidth: CGFloat {
        var insets: NSEdgeInsets = NSEdgeInsetsZero
        switch sectionInsetReference {
        case .fromContentInset:
            if let contentInsets = collectionView?.enclosingScrollView?.contentInsets {
                insets = contentInsets
            } else { insets = NSEdgeInsetsZero  }
        case .fromSafeArea:
            if #available(macOS 11.0, *) {
                insets = collectionView!.safeAreaInsets
            } else { insets = NSEdgeInsetsZero  }
        }
        return collectionView!.bounds.size.width - insets.left - insets.right
    }
    
    private func collectionViewContentWidth(ofSection section: Int) -> CGFloat {
        var insets = delegate?.collectionView(collectionView!, layout: self, insetsFor: section) ?? sectionInset
        if (insets.bottom == -1) {
            insets = self.sectionInset
        }
        return collectionViewContentWidth - insets.left - insets.right
    }
    
    public func itemWidth(inSection section: Int) -> CGFloat {
        let columnCount = self.columnCount(forSection: section)
        let spaceColumCount = CGFloat(columnCount - 1)
        let width = collectionViewContentWidth(ofSection: section)
        return floor((width - (spaceColumCount * minimumColumnSpacing)) / CGFloat(columnCount))
    }
    
    override public func prepare() {
        super.prepare()
        
        let numberOfSections = collectionView!.numberOfSections
        if numberOfSections == 0 {
            return
        }
        
        headersAttributes = [:]
        footersAttributes = [:]
        unionRects = []
        allItemAttributes = []
        sectionItemAttributes = []
        columnHeights = (0 ..< numberOfSections).map { section in
            let columnCount = self.columnCount(forSection: section)
            let sectionColumnHeights = (0 ..< columnCount).map { CGFloat($0) }
            return sectionColumnHeights
        }
        
        var top: CGFloat = 0.0
        var attributes = NSUICollectionViewLayoutAttributes()
        
        for section in 0 ..< numberOfSections {
            // MARK: 1. Get section-specific metrics (minimumInteritemSpacing, sectionInset)
            var minimumInteritemSpacing  =  delegate?.collectionView(collectionView!, layout: self, minimumInteritemSpacingFor: section) ?? self.minimumInteritemSpacing
            if minimumInteritemSpacing == -1 {
                minimumInteritemSpacing = self.minimumInteritemSpacing
            }
            
            var sectionInsets  =  delegate?.collectionView(collectionView!, layout: self, insetsFor: section) ?? self.sectionInset
            if sectionInsets.bottom == -1 {
                sectionInsets =  self.sectionInset
            }
            
            let columnCount = columnHeights[section].count
            let itemWidth = self.itemWidth(inSection: section)
            
            // MARK: 2. Section header
            var heightHeader = delegate?.collectionView(collectionView!, layout: self, heightForHeaderIn: section) ?? self.headerHeight
            if (heightHeader == -1) {
                heightHeader =  self.headerHeight
            }
            if heightHeader > 0 {
                attributes = NSUICollectionViewLayoutAttributes(forSupplementaryViewOfKind: NSCollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: collectionView!.bounds.size.width, height: heightHeader)
                headersAttributes[section] = attributes
                allItemAttributes.append(attributes)
                
                top = attributes.frame.maxY
            }
            top += sectionInsets.top
            columnHeights[section] = [CGFloat](repeating: top, count: columnCount)
            
            // MARK: 3. Section items
            let itemCount = collectionView!.numberOfItems(inSection: section)
            var itemAttributes: [NSUICollectionViewLayoutAttributes] = []
            
            // Item will be put into shortest column.
            for idx in 0 ..< itemCount {
                let indexPath = IndexPath(item: idx, section: section)
                
                let columnIndex = nextColumnIndexForItem(idx, inSection: section)
                let xOffset = sectionInsets.left + (itemWidth + minimumColumnSpacing) * CGFloat(columnIndex)
                
                let yOffset = columnHeights[section][columnIndex]
                var itemHeight: CGFloat = 0.0
                if let itemSize = delegate?.collectionView(collectionView!, layout: self, sizeForItemAt: indexPath),
                   itemSize.height > 0 {
                    itemHeight = itemSize.height
                    if itemSize.width > 0 {
                        itemHeight = floor(itemHeight * itemWidth / itemSize.width)
                    } // else use default item width based on other parameters
                }
                
                attributes = NSUICollectionViewLayoutAttributes(forItemWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                itemAttributes.append(attributes)
                allItemAttributes.append(attributes)
                columnHeights[section][columnIndex] = attributes.frame.maxY + minimumInteritemSpacing
            }
            sectionItemAttributes.append(itemAttributes)
            
            // MARK: 4. Section footer
            let columnIndex  = longestColumnIndex(inSection: section)
            top = columnHeights[section][columnIndex] - minimumInteritemSpacing + sectionInsets.bottom
            var footerHeight = delegate?.collectionView(collectionView!, layout: self, heightForFooterIn: section) ?? self.footerHeight
            if (footerHeight == -1) {
                footerHeight = self.footerHeight
            }
            
            if footerHeight > 0 {
                attributes = NSUICollectionViewLayoutAttributes(forSupplementaryViewOfKind: NSCollectionView.elementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: top, width: collectionView!.bounds.size.width, height: footerHeight)
                footersAttributes[section] = attributes
                allItemAttributes.append(attributes)
                top = attributes.frame.maxY
            }
            
            columnHeights[section] = [CGFloat](repeating: top, count: columnCount)
        }
        
        var idx = 0
        let itemCounts = allItemAttributes.count
        while idx < itemCounts {
            let rect1 = allItemAttributes[idx].frame
            idx = min(idx + unionSize, itemCounts) - 1
            let rect2 = allItemAttributes[idx].frame
            unionRects.append(rect1.union(rect2))
            idx += 1
        }
    }
    
    override public var collectionViewContentSize: CGSize {
        if collectionView!.numberOfSections == 0 {
            return .zero
        }
        
        var contentSize = collectionView!.bounds.size
        contentSize.width = collectionViewContentWidth
        
        if let height = columnHeights.last?.first {
            contentSize.height = height
            return contentSize
        }
        return .zero
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> NSUICollectionViewLayoutAttributes? {
        if indexPath.section >= sectionItemAttributes.count {
            return nil
        }
        let list = sectionItemAttributes[indexPath.section]
        if indexPath.item >= list.count {
            return nil
        }
        return list[indexPath.item]
    }
    
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> NSUICollectionViewLayoutAttributes {
        var attribute: NSUICollectionViewLayoutAttributes?
        if elementKind == NSCollectionView.elementKindSectionHeader {
            attribute = headersAttributes[indexPath.section]
        } else if elementKind == NSCollectionView.elementKindSectionFooter {
            attribute = footersAttributes[indexPath.section]
        }
        return attribute ?? NSUICollectionViewLayoutAttributes()
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [NSUICollectionViewLayoutAttributes] {
        var begin = 0, end = unionRects.count
        
        if let i = unionRects.firstIndex(where: { rect.intersects($0) }) {
            begin = i * unionSize
        }
        if let i = unionRects.lastIndex(where: { rect.intersects($0) }) {
            end = min((i + 1) * unionSize, allItemAttributes.count)
        }
        return allItemAttributes[begin..<end]
            .filter { rect.intersects($0.frame) }
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return newBounds.width != collectionView?.bounds.width
    }
    
    private func shortestColumnIndex(inSection section: Int) -> Int {
        return columnHeights[section].enumerated()
            .min(by: { $0.element < $1.element })?
            .offset ?? 0
    }
    
    private func longestColumnIndex(inSection section: Int) -> Int {
        return columnHeights[section].enumerated()
            .max(by: { $0.element < $1.element })?
            .offset ?? 0
    }

    private func nextColumnIndexForItem(_ item: Int, inSection section: Int) -> Int {
        var index = 0
        let columnCount = self.columnCount(forSection: section)
        switch itemRenderDirection {
        case .shortestFirst :
            index = shortestColumnIndex(inSection: section)
        case .leftToRight :
            index = item % columnCount
        case .rightToLeft:
            index = (columnCount - 1) - (item % columnCount)
        }
        return index
    }
}
}
