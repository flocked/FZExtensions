//
//  File.swift
//  
//
//  Created by Florian Zand on 23.08.22.
//

#if os(macOS)
import AppKit
public typealias NSUIImage = NSImage
public typealias NSUIView = NSView
public typealias NSUIBezierPath = NSBezierPath
public typealias NSUIColor = NSColor
public typealias NSUIFont = NSFont
public typealias NSUIEdgeInsets = NSEdgeInsets
public typealias NSUICollectionView = NSCollectionView
public typealias NSUICollectionViewLayoutAttributes = NSCollectionViewLayoutAttributes
public typealias NSUICollectionViewCompositionalLayout = NSCollectionViewCompositionalLayout
public typealias NSUICollectionViewLayout = NSCollectionViewLayout
public typealias NSUICollectionViewDelegate = NSCollectionViewDelegate
public typealias NSUICollectionViewCompositionalLayoutConfiguration = NSCollectionViewCompositionalLayoutConfiguration
public typealias NSUIConfigurationColorTransformer = NSConfigurationColorTransformer
#elseif canImport(UIKit)
import UIKit
public typealias NSUIImage = UIImage
public typealias NSUIColor = UIColor
public typealias NSUIFont = UIFont
public typealias NSUICollectionView = UICollectionView
public typealias NSUIView = UIView
public typealias NSUIBezierPath = UIBezierPath
public typealias NSUIEdgeInsets = UIEdgeInsets
public typealias NSUICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes
public typealias NSUICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout
public typealias NSUICollectionViewLayout = UICollectionViewLayout
public typealias NSUICollectionViewDelegate = UICollectionViewDelegate
public typealias NSUICollectionViewCompositionalLayoutConfiguration = UICollectionViewCompositionalLayoutConfiguration
public typealias NSUIConfigurationColorTransformer = UIConfigurationColorTransformer
#endif
