//
//  FinalLabel.swift
//  CollectionTableView
//
//  Created by Florian Zand on 11.10.22.
//

#if os(macOS)
import SwiftUI
@available(macOS 12.0, *)
public class FZSWLabel: NSView {
    internal var hostingView: NSHostingView<ContentView>!
    public var configuration = Configuration() {
        didSet { self.updateHostingView() } }
    
    public var text: String? {
        get { configuration.text }
        set { configuration.text = newValue }
    }
    
    public var systemName: String? {
        get { configuration.systemImage }
        set { configuration.systemImage = newValue }
    }
    
    public var margin: CGFloat {
        get { configuration.margin }
        set { configuration.margin = newValue }
    }
    
    public var iconToTextPadding: CGFloat {
        get { configuration.iconToTextPadding }
        set { configuration.iconToTextPadding = newValue }
    }
    
    public var textStyle: Configuration.TextStyle {
        get { configuration.textStyle }
        set { configuration.textStyle = newValue }
    }
    
    public var weight: NSFont.Weight {
        get { configuration.weight }
        set { configuration.weight = newValue }
    }
    
    public var imageScale: NSImage.SymbolScale {
        get { configuration.imageScale }
        set { configuration.imageScale = newValue }
    }
    
    public var foregroundColor: NSColor {
        get { configuration.foregroundColor }
        set { configuration.foregroundColor = newValue }
    }
    
    public var shape: Configuration.LabelShape {
        get { configuration.shape }
        set { configuration.shape = newValue }
    }
    
    public var background: Configuration.Background {
        get { configuration.background }
        set { configuration.background = newValue }
    }
    
    public var borderWidth: CGFloat {
        get { configuration.borderWidth }
        set { configuration.borderWidth = newValue }
    }
    
    public var imagePosition: Configuration.IconPlacement {
        get { configuration.iconPlacement }
        set { configuration.iconPlacement = newValue }
    }
    
    public var labelShadow: Configuration.ShadowProperties {
        get { configuration.shadow }
        set { configuration.shadow = newValue }
    }
    
    public func sizeToFit() {
        self.frame.size = self.fittingSize
        hostingView.frame.size = self.fittingSize
    }
    
    internal func updateHostingView() {
        hostingView.rootView = ContentView(properties: self.configuration)
        sizeToFit()
    }
    
    public override var intrinsicContentSize: NSSize {
        return self.fittingSize
    }
    
    public override var fittingSize: NSSize {
        return hostingView.fittingSize
    }
    
    internal func sharedInit() {
        self.hostingView = NSHostingView<ContentView>(rootView: ContentView(properties: self.configuration))
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        self.addSubview(self.hostingView)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.sizeToFit()
    }
    
    public init() {
        super.init(frame: .zero)
        self.sharedInit()
    }
    
    public init(text: String) {
        super.init(frame: .zero)
        self.sharedInit()
        self.text = text
        self.updateHostingView()
    }
    
    public init(text: String, systemName: String) {
        super.init(frame: .zero)
        self.sharedInit()
        self.text = text
        self.systemName = systemName
        self.updateHostingView()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.sharedInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
