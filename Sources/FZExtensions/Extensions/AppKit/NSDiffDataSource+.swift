//
//  DiffableDataSource+.swift
//  FZCollection
//
//  Created by Florian Zand on 02.05.22.
//

#if os(macOS)

import Foundation
import AppKit

@available(macOS 10.15.1, *)
public extension NSDiffableDataSourceSnapshot {
    enum ApplyOption {
        case reloadData
        case animated
        case non
    }
}

public protocol HashIdentifiable: Identifiable, Hashable { }

public extension HashIdentifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

@available(macOS 10.15.1, *)
public extension NSCollectionViewDiffableDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
    typealias SnapshotApplyOption = Snapshot.ApplyOption
    
    func itemIdentifiers(for indexPaths: [IndexPath]) -> [ItemIdentifierType] {
       return indexPaths.compactMap({self.itemIdentifier(for:$0)})
    }
    
    func indexPaths(for identifiers: [ItemIdentifierType]) -> [IndexPath] {
       return identifiers.compactMap({self.indexPath(for: $0)})
    }
        
    func apply(_ snapshot: Snapshot,_ option: Snapshot.ApplyOption? = nil, completion: (() -> Void)? = nil) {
        if let option = option {
            switch option {
            case .reloadData:
                self.applySnapshotUsingReloadData(snapshot, completion: completion)
            case .animated:
                self.applySnapshot(snapshot, animated: true, completion: completion)
            case .non:
                self.applySnapshot(snapshot, animated: false, completion: completion)
            }
        } else {
            self.applySnapshot(snapshot, animated: false, completion: completion)
        }
    }
    
   private func applySnapshotUsingReloadData(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        completion: (() -> Void)? = nil) {
            self.apply(snapshot, animatingDifferences: false, completion: completion)
    }
    
    private  func applySnapshot(
        _ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        animated: Bool = true,
        completion: (() -> Void)? = nil) {
            if animated {
                self.apply(snapshot, animatingDifferences: true, completion: completion)
            } else {
                NSAnimationContext.beginGrouping()
                NSAnimationContext.current.duration = 0
                    self.apply(snapshot, animatingDifferences: true, completion: completion)
                NSAnimationContext.endGrouping()
        }
    }
}

@available(macOS 11.0, *)
public extension NSTableViewDiffableDataSource {
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>
    typealias SnapshotApplyOption = Snapshot.ApplyOption
    
    func itemIdentifiers(for rows: [Int]) -> [ItemIdentifierType] {
       return rows.compactMap({self.itemIdentifier(forRow:$0)})
    }
    
    func rows(for identifiers: [ItemIdentifierType]) -> [Int] {
       return identifiers.compactMap({self.row(forItemIdentifier: $0)})
    }
    
    func apply(_ snapshot: Snapshot,_ option: SnapshotApplyOption? = nil, completion: (() -> Void)? = nil) {
        if let option = option {
            switch option {
            case .reloadData:
                self.applySnapshotUsingReloadData(snapshot, completion: completion)
            case .animated:
                self.applySnapshot(snapshot, animated: true, completion: completion)
            case .non:
                self.applySnapshot(snapshot, animated: false, completion: completion)
            }
        } else {
            self.applySnapshot(snapshot, animated: false, completion: completion)
        }
    }
    
   private func applySnapshotUsingReloadData(_
        snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        completion: (() -> Void)? = nil) {
            self.apply(snapshot, animatingDifferences: false, completion: completion)
    }

    private func applySnapshot(
        _ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        animated: Bool = true,
        completion: (() -> Void)? = nil) {
            if animated {
                self.apply(snapshot, animatingDifferences: true, completion: completion)
            } else {
                NSAnimationContext.beginGrouping()
                NSAnimationContext.current.duration = 0
                    self.apply(snapshot, animatingDifferences: true, completion: completion)
                NSAnimationContext.endGrouping()
        }
    }
}

#endif
