//
//  File.swift
//  
//
//  Created by Florian Zand on 23.08.22.
//

#if os(macOS)
import AppKit
public typealias Image = NSImage
public typealias Color = NSColor
public typealias CollectionView = NSCollectionView
public typealias CollectionViewCompositionalLayout = NSCollectionViewCompositionalLayout
public typealias CollectionViewLayout = NSCollectionViewLayout
public typealias CollectionViewCompositionalLayoutConfiguration = NSCollectionViewCompositionalLayoutConfiguration
#elseif canImport(UIKit)
public import UIKit
public typealias Image = UIImage
public typealias Color = UIColor
public typealias CollectionView = UICollectionView
public typealias CollectionViewCompositionalLayout = UICollectionViewCompositionalLayout
public typealias CollectionViewLayout = UICollectionViewLayout
public typealias CollectionViewCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration
#endif
