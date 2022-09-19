//
//  TokenFieldTokenView.swift
//  TokenField
//
//  Created by Umur Gedik on 22.05.2021.
//

#if os(macOS)

import AppKit
import SwiftUI

public class TokenView: NSView {
    public enum CornerStyle: Codable {
        case capsule
        case fixed(CGFloat)
        case rect
        case relative(CGFloat)
        case small
        case medium
        case large
    }
    
    public enum BackgroundStyle {
        case clear
        case color(NSColor)
        case visualEffect(VisualEffectStyle)
        
        public struct VisualEffectStyle {
            public   var blendingMode: NSVisualEffectView.BlendingMode = .withinWindow
            public   var material: NSVisualEffectView.Material = .hudWindow
            public   var appearance: NSAppearance.Name? = nil
            public    static func `default`() -> Self { return self.init() }
            public    static func appearance(_ name: NSAppearance.Name) -> Self { return self.init(appearance: name) }

            public   static func darkAqua() -> Self { return self.init(appearance: .darkAqua) }
            public   static func aqua() -> Self { return self.init(appearance: .aqua) }
            public  static func vibrantDark() -> Self { return self.init(appearance: .vibrantDark) }
            public  static func vibrantLight() -> Self { return self.init(appearance: .vibrantLight) }
        }
        
    }
    
    public var backgroundStyle: BackgroundStyle = .color(.controlAccentColor) {
        didSet { needsDisplay = true } }
    
    public struct Configuration {
        var opacity: Float?
        var cornerStyle: CornerStyle?
        var font: NSFont?
        var foregorundColor: NSColor?
        var backgroundStyle: BackgroundStyle?
        var imageSizeScaling: CGFloat?
        var paddings: NSDirectionalEdgeInsets?
        var imagePadding: CGFloat?
        var imageScaling: NSImageScaling?
        var imagePosition: NSDirectionalRectEdge?
        var borderWidth: CGFloat?
        var borderColor: NSColor?
        var size: CGFloat?
        
        public static func tinted(_ color: NSColor) -> Configuration {
            return Configuration(cornerStyle: .small,foregorundColor: color, backgroundStyle: .color(color.color(brightness: 1.5)))
        }
        
        public static func colored(_ color: NSColor) -> Configuration {
            return Configuration(cornerStyle: .small, backgroundStyle: .color(color))
        }
        
        public static func opacity(_ opacity: Float) -> Configuration {
            return Configuration(opacity: opacity)
        }
        
        public static func coloredBorered(_ color: NSColor) -> Configuration {
            return Configuration(cornerStyle: .small, backgroundStyle: .color(color), borderWidth: 2.0)
        }
        
        public  static func bordered(_ color: NSColor) -> Configuration {
            return Configuration(cornerStyle: .small, foregorundColor: nil, backgroundStyle: nil, borderWidth: 4.0, borderColor: NSColor.controlAccentColor)
        }
        public static func borderedColored(_ color: NSColor) -> Configuration {
            return Configuration(cornerStyle: .small, foregorundColor: color, backgroundStyle: nil, borderWidth: 4.0, borderColor: NSColor.controlAccentColor)
        }
    }
    
    var currentConfiguration: Configuration {
        return Configuration(opacity: self.opacity,
                             cornerStyle: self.cornerStyle,
                             font: self.font,
                             foregorundColor: self.foregroundColor,
                             backgroundStyle: self.backgroundStyle,
                             imageSizeScaling: self.imageSizeScaling,
                             paddings: self.paddings,
                             imagePadding: self.imagePadding,
                             imageScaling: self.imageScaling,
                             imagePosition: self.imagePosition,
                             borderWidth: self.borderWidth,
                             borderColor: self.borderColor)
    }
    
    public  func applyConfiguration(_ newConfiguration: Configuration) {
        if let value = newConfiguration.opacity {
            self.opacity = value
        }
        
        if let value = newConfiguration.cornerStyle {
            self.cornerStyle = value
        }
        if let value = newConfiguration.font {
            self.font = value
        }
        if let value = newConfiguration.foregorundColor {
            self.foregroundColor = value
        }
        if let value = newConfiguration.backgroundStyle {
            self.backgroundStyle = value
        }
        if let value = newConfiguration.imageSizeScaling {
            self.imageSizeScaling = value
        }
        if let value = newConfiguration.paddings {
            self.paddings = value
        }
        if let value = newConfiguration.imagePadding {
            self.imagePadding = value
        }
        if let value = newConfiguration.imageScaling {
            self.imageScaling = value
        }
        if let value = newConfiguration.imagePosition {
            self.imagePosition = value
        }
        if let value = newConfiguration.borderWidth {
            self.borderWidth = value
        }
        if let value = newConfiguration.borderColor {
            self.borderColor = value
        }
        if let value = newConfiguration.size {
            self.sizeToFit(height: value)
        }
    }
    
    internal let textField = ResizingTextField(labelWithString: "")
    internal var imageView: NSImageView? = nil

    public var title: String {
        get { textField.stringValue }
        set { textField.stringValue = newValue }
    }
    
    public var opacity: Float = 1.0 {
        didSet { needsDisplay = true } }
    
    public var cornerStyle: CornerStyle = .small {
        didSet { needsDisplay = true }
    }
    
    public var font: NSFont  {
        get { textField.font ?? .systemFont(ofSize: self.bounds.height) }
        set { textField.font = newValue}
    }
    
    public var foregroundColor = NSColor.white {
        didSet {
            self.textField.textColor = self.foregroundColor
            self.imageView?.contentTintColor = foregroundColor
         }
    }
        
    public var image: NSImage? = nil {
        didSet { self.updateImageView() }
    }
    
    internal func addImageView() {
        if (imageView == nil) {
            self.imageView = NSImageView()
            self.imageView?.imageScaling = self.imageScaling
            self.imageView?.translatesAutoresizingMaskIntoConstraints = false
            self.imageView?.contentTintColor = self.foregroundColor
            self.addSubview(imageView!)
        }
    }
    
    internal func removeImageView() {
        self.imageView?.removeFromSuperview()
        self.imageView = nil
    }
    
    internal func updateImageView() {
        if let image = image {
            self.addImageView()
            self.imageView?.image = image
        } else {
            self.removeImageView()
        }
    }
    
    public var imageScaling: NSImageScaling = .scaleAxesIndependently {
        didSet {
            self.imageView?.imageScaling = self.imageScaling
        }
    }
    
    public var imagePadding: CGFloat = 6.0 {
        didSet { updateActiveConstraints()  }
    }
    
    public var imageSizeScaling: CGFloat = 0.8 {
        didSet { updateActiveConstraints()  }
    }
    
    public var imagePosition: NSDirectionalRectEdge = .trailing {
        didSet { updateActiveConstraints() }
    }
    
    internal var fittingString: String {
        var fitString = self.title
        if (self.title == "") {
            if let placeholder = self.placeholderString, placeholder != "" {
                 fitString = placeholder
            } else {
                fitString = "     "
            }
        }
        return fitString
    }
    
    public func sizeToFit(width: CGFloat) {
        let width  = width - (self.paddings.leading + self.paddings.trailing)
        self.font = font.sized(toFit: fittingString, width: width)
    }
        
    public func sizeToFit(height: CGFloat) {
        let height  = height - (self.paddings.top + self.paddings.bottom)
        self.font = font.sized(toFit: fittingString, height: height)
    }
    
    public var maxWidth: CGFloat? {
        get { textField.maxWidth }
        set { textField.maxWidth = newValue }
    }
    
    public var isEditable: Bool {
        get { textField.isEditable }
        set { textField.isEditable = newValue }
    }
    
   // public var isSelectable: Bool = true {
  //      didSet { needsDisplay = true } }
    
    public var placeholderString: String? {
        get { textField.placeholderString }
        set { textField.placeholderString = newValue }
    }
    
 //   public var backgroundColor: NSColor? = NSColor.controlAccentColor {
   //     didSet { needsDisplay = true } }

    public var borderWidth = 0.0 {
        didSet { needsDisplay = true } }
    
    public var borderColor: NSColor? = nil {
        didSet { needsDisplay = true } }
    
    public var isSelected = false {
        didSet {
            if isSelectable, let configuration = self.selectedConfiguration {
                self.applyConfiguration(configuration)
            } else  if isSelectable == false, let configuration = self.nonSelectedConfiguration {
                self.applyConfiguration(configuration)
            }
        } }
    
    public override func mouseDown(with event: NSEvent) {
        self.toggleIsSelected()
        super.mouseDown(with: event)
    }
    
    public override func rightMouseDown(with theEvent: NSEvent) {
        self.toggleIsSelected()
        super.rightMouseDown(with: theEvent)
    }
    
    public func toggleIsSelected() {
        if (isSelectable) {
            self.isSelected = !self.isSelected
        }
    }
    
    var selectedConfiguration: Configuration? = .opacity(1.0)
    var nonSelectedConfiguration: Configuration? = .opacity(0.7)

    
    public var paddings = NSDirectionalEdgeInsets(1) {
        didSet {
            updateActiveConstraints()
        }
    }
    
   public func setEqualPadding(_ value: CGFloat) {
        self.imagePadding = value
        self.paddings =  NSDirectionalEdgeInsets(value)
    }
    
    public override var acceptsFirstResponder: Bool {
        return true
    }
    
    internal var activeLayoutConstraints: [NSLayoutConstraint] = []
    internal func updateActiveConstraints() {
        NSLayoutConstraint.deactivate(activeLayoutConstraints)
        var paddings = self.paddings
        paddings.leading = self.paddings.leading + 2
        paddings.trailing = self.paddings.trailing + 2
        Swift.print(paddings)

        if let imageView = imageView {
            switch imagePosition {
            case .leading, .bottom:
                activeLayoutConstraints = [
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddings.leading),
                imageView.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -imagePadding),
                textField.topAnchor.constraint(equalTo: self.topAnchor, constant: paddings.top),
                textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: paddings.bottom),
                textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -paddings.trailing),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                imageView.heightAnchor.constraint(equalToConstant: textField.bounds.height*self.imageSizeScaling),
                imageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),]
                NSLayoutConstraint.activate(activeLayoutConstraints)
            case .trailing, .top:
                activeLayoutConstraints = [
                imageView.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: imagePadding),
                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -paddings.trailing),
                textField.topAnchor.constraint(equalTo: self.topAnchor, constant: -paddings.top),
                textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddings.leading),
                textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: paddings.bottom),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                imageView.heightAnchor.constraint(equalToConstant: textField.bounds.height*self.imageSizeScaling),
                imageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
                ]
                NSLayoutConstraint.activate(activeLayoutConstraints)
            default:
                break
            }
        } else {
            activeLayoutConstraints = [
            self.topAnchor.constraint(equalTo: textField.topAnchor, constant: -paddings.top),
            self.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -paddings.leading),
            self.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: paddings.bottom),
            self.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: paddings.trailing),
            ]
            NSLayoutConstraint.activate(activeLayoutConstraints)
        }
         
    }
    
    internal var capsulePading: CGFloat = 0.0 {
        didSet {
            self.updateActiveConstraints()
        }
    }
    
    public override var wantsUpdateLayer: Bool { true }
    
    public  convenience init(string: String? = nil, placeholder: String? = nil, color: NSColor = .controlAccentColor, image: NSImage? = nil, height: CGFloat) {
        self.init(string: string)
        self.placeholderString = placeholder
        self.backgroundColor = color
        self.image = image
     //   self.sizeToFit(height: height)
    }
    
    internal let isSelectedAlphaValue: CGFloat = 0.75
    public init(string: String? = nil, color: NSColor = .controlAccentColor, paddings: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(2)) {
        self.paddings = paddings
        super.init(frame: NSRect(x: 0, y: 0, width: 10, height: 10))
        wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        textField.drawsBackground = false
        textField.font = .systemFont(ofSize: NSFont.systemFontSize(for: .regular))
    //    textField.backgroundColor = nil
        textField.isBordered = false
        textField.textColor = self.foregroundColor
        textField.isEditable = false
        textField.focusRingType = .none
        NSLayoutConstraint.activate(activeLayoutConstraints)
        self.backgroundColor = color
        if let string = string {
            textField.stringValue = string
            self.title = string
        }
        self.font = .systemFont(ofSize: NSFont.systemFontSize(for: .regular))
        self.invalidateIntrinsicContentSize()
        self.frame.size = self.textField.fittingSize
        self.updateActiveConstraints()
        textField.editingStateHandler = textFieldEditStateChanged
    }
    
   internal func textFieldEditStateChanged(_ state: ResizingTextField.EditState) {
        if (state != .didEnd) {
            Swift.print("dfdff")
            self.wantsLayer = true
            self.layer?.masksToBounds = false
            self.layer?.shadowColor = NSColor.controlAccentColor.cgColor
            self.layer?.shadowOpacity = 1.0
            self.layer?.shadowRadius = 2.0
       //     self.layer?.borderColor = .white
     //       self.layer?.borderWidth = 0.5
            self.layer?.shadowOffset = CGSize(width: 0.0, height: 0.0)
        } else {
            self.layer?.shadowOpacity = 0.0
  //          self.layer?.borderWidth = 0.0
            self.layer?.shadowColor = nil
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal var visualEffectView: NSVisualEffectView? = nil
    internal func addVisualEffectView() {
        if (self.visualEffectView == nil) {
            self.visualEffectView = NSVisualEffectView()
            self.visualEffectView?.blendingMode = .withinWindow
            self.visualEffectView?.material = .hudWindow
            self.visualEffectView?.state = .followsWindowActiveState
            self.addSubview(withConstraint: self.visualEffectView!)
            self.visualEffectView?.sendToBack()
        }
    }
    
    internal func removeVisualEffectView() {
        self.visualEffectView?.removeFromSuperview()
        self.visualEffectView = nil
    }
    
    public override func updateLayer() {
        super.updateLayer()
        guard let layer = self.layer else { return }
        switch self.backgroundStyle {
        case .clear:
            self.removeVisualEffectView()
            layer.backgroundColor = nil
            layer.opacity = self.opacity
        case .color(let color):
            self.removeVisualEffectView()
            layer.backgroundColor = color.withAlphaComponent(CGFloat(self.opacity)).cgColor
        case .visualEffect(let style):
            self.addVisualEffectView()
            if let name = style.appearance {
                self.visualEffectView?.appearance = NSAppearance(named: name)!
            }
            self.visualEffectView?.material = style.material
            self.visualEffectView?.blendingMode = style.blendingMode
            layer.backgroundColor = nil
            layer.opacity = self.opacity
        }
        
        /*
        if let backgroundColor = self.backgroundColor {
            layer.backgroundColor = backgroundColor.withAlphaComponent(CGFloat(self.opacity)).cgColor
            layer.opacity = 1.0
        } else {
            layer.opacity = self.opacity
        }
         */
        
        switch cornerStyle {
        case .capsule:
            layer.cornerCurve = .continuous
            layer.cornerRadius = self.bounds.height/2.0
            capsulePading = self.bounds.height/4.0
        case .fixed(let value):
            layer.cornerCurve = .circular
            layer.cornerRadius = value
            capsulePading = 0
        case .rect:
            layer.cornerCurve = .circular
            layer.cornerRadius = 0
            capsulePading = 0
        case .relative(let value):
            let value = value/2.0
            layer.cornerCurve = .circular
            layer.cornerRadius = self.bounds.height*value
            capsulePading = 0
        case .small:
            layer.cornerCurve = .circular
            layer.cornerRadius = 4.0
            capsulePading = 0
        case .medium:
            layer.cornerCurve = .circular
            layer.cornerRadius = 8.0
            capsulePading = 0
        case .large:
            layer.cornerCurve = .circular
            layer.cornerRadius = 12.0
            capsulePading = 0
        }
        layer.borderWidth = self.borderWidth
        layer.borderColor = self.borderColor?.cgColor ?? foregroundColor.cgColor
    }
}

#endif
