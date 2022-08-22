//
//  NSCollectionViewCompo.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//

import Foundation
import AppKit

extension NSCollectionViewCompositionalLayout {
//struct Layout {
    static func list(rowHeight: CGFloat) -> NSCollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(rowHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
      
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = NSCollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    static func fullSize(paging: Bool, direction: NSCollectionView.ScrollDirection)-> NSCollectionViewLayout{
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let layoutGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = paging ? .paging : .continuous
        let config = NSCollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = direction
        let layout = NSCollectionViewCompositionalLayout(section: layoutSection, configuration: config)
        return layout
    }

    static func grid(columns: Int = 3, itemAspectRatio: CGSize = CGSize(1,1), spacing: CGFloat = 0.0, insets: NSDirectionalEdgeInsets = .zero, header: SupplementaryItemType? = nil, footer: SupplementaryItemType? = nil) -> NSCollectionViewLayout {
          return NSCollectionViewCompositionalLayout { (section: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

              // Item
              let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemAspectRatio.width/itemAspectRatio.height),
                                                    heightDimension: .fractionalHeight(1))

              let item = NSCollectionLayoutItem(layoutSize: itemSize)

              // Group
              let groupHeight: CGFloat = {
                  let totalSpacing = spacing * (CGFloat(columns) - 1)
                  let horizontalInsets = insets.leading + insets.trailing

                  let itemWidth = (layoutEnvironment.container.effectiveContentSize.width - totalSpacing - horizontalInsets)/CGFloat(columns)

                  return itemWidth * itemAspectRatio.height/itemAspectRatio.width
              }()

              let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .absolute(groupHeight))

              let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
              group.interItemSpacing = .fixed(spacing)

              // Section
              let section = NSCollectionLayoutSection(group: group)
              section.interGroupSpacing = spacing
              section.contentInsets = insets

              // Header & Footer
              if let headerItem = header?.item(elementKind: "Header") {
                  section.boundarySupplementaryItems.append(headerItem)
              }
              if let footherItem = footer?.item(elementKind: "Footer") {
                  section.boundarySupplementaryItems.append(footherItem)
              }
              return section
          }
}
}

extension NSCollectionViewCompositionalLayout {
    enum SupplementaryItemType {
        case normal(height: CGFloat)
        case pinToTop(height: CGFloat)
        
        fileprivate var pinToVisibleBounds: Bool {
            switch self {
            case .normal(_): return false
            case .pinToTop(_): return true }}
        
        fileprivate var height: CGFloat {
            switch self {
            case .normal(let height): return height
            case .pinToTop(let height): return height }
            
        }
        
        func item(elementKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
            let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(self.height))
            let item = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: elementKind, alignment: .top)
            item.pinToVisibleBounds = self.pinToVisibleBounds
            return item
        }
    }
}

/*
 static func grid(column: Int, scrollDirection: NSCollectionView.ScrollDirection) -> NSCollectionLayoutSection {
     let subitem = NSCollectionLayoutItem(
         layoutSize: NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1 / CGFloat(column)),
             heightDimension: .fractionalHeight(1)
         )
     )
     let group = NSCollectionLayoutGroup.horizontal(
         layoutSize: NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1),
             heightDimension: .fractionalWidth(1 / CGFloat(column))
         ),
         subitem: subitem,
         count: column
     )
     group.interItemSpacing = .fixed(1)
     
     let section = NSCollectionLayoutSection(group: group)
     section.interGroupSpacing = 1
     section.contentInsets = .init(top: 1, leading: 1, bottom: 0, trailing: 1)
     
     return section
 }
 */

