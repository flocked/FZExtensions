//
//  TokenFieldTokenView.swift
//  TokenField
//
//  Created by Umur Gedik on 22.05.2021.
//

#if os(macOS)

import AppKit

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
        case visualEffect(NSAppearance.Name)
        
        public enum VisualEffectStlye: Codable {
            case aqua
            case darkAqua
            case vibrant
            case vibrantLight
            var appe: NSAppearance {
                switch self {
                case .aqua:
                   return NSAppearance(named: .aqua)!
                case .darkAqua:
                    return NSAppearance(named: .darkAqua)!
                case .vibrant:
                    return NSAppearance(named: .vibrantLight)!
                case .vibrantLight:
                    return NSAppearance(named: .vibrantDark)!
                }
            }
        }
    }
    
    public var backgroundStyle: BackgroundStyle = .color(.controlAccentColor) {
        didSet { needsDisplay = true } }
    
    public struct Configuration {
        var opacity: Float?
        var cornerStyle: CornerStyle?
        var font: NSFont?
        var foregorundColor: NSColor?
        var backgroundColor: NSColor?
        var imageSizeScaling: CGFloat?
        var paddings: NSDirectionalEdgeInsets?
        var imagePadding: CGFloat?
        var imageScaling: NSImageScaling?
        var imagePosition: NSDirectionalRectEdge?
        var borderWidth: CGFloat?
        var borderColor: NSColor?
        var size: CGFloat?
        
        static func colored(_ color: NSColor) -> Configuration {
            return Configuration(cornerStyle: .small, backgroundColor: color)
        }
        
        static func opacity(_ opacity: Float) -> Configuration {
            return Configuration(opacity: opacity)
        }
        
        static func coloredBorered(_ color: NSColor) -> Configuration {
            return Configuration(cornerStyle: .small, backgroundColor: color, borderWidth: 2.0)
        }
        
        static func bordered(_ color: NSColor) -> Configuration {
            return Configuration(cornerStyle: .small, foregorundColor: nil, backgroundColor: nil, borderWidth: 4.0, borderColor: NSColor.controlAccentColor)
        }
        static func borderedColored(_ color: NSColor) -> Configuration {
            return Configuration(cornerStyle: .small, foregorundColor: color, backgroundColor: nil, borderWidth: 4.0, borderColor: NSColor.controlAccentColor)
        }
    }
    
    var currentConfiguration: Configuration {
        return Configuration(opacity: self.opacity,
                             cornerStyle: self.cornerStyle,
                             font: self.font,
                             foregorundColor: self.foregroundColor,
                             backgroundColor: self.backgroundColor,
                             imageSizeScaling: self.imageSizeScaling,
                             paddings: self.paddings,
                             imagePadding: self.imagePadding,
                             imageScaling: self.imageScaling,
                             imagePosition: self.imagePosition,
                             borderWidth: self.borderWidth,
                             borderColor: self.borderColor)
    }
    
    func applyConfiguration(_ newConfiguration: Configuration) {
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
        if let value = newConfiguration.backgroundColor {
            self.backgroundColor = value
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
    
    private let textField = ResizingTextField(labelWithString: "")
    private var imageView: NSImageView? = nil

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
        set { textField.font = newValue
        }
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
    
    private func addImageView() {
        if (imageView == nil) {
            self.imageView = NSImageView()
            self.imageView?.imageScaling = self.imageScaling
            self.imageView?.translatesAutoresizingMaskIntoConstraints = false
            self.imageView?.contentTintColor = self.foregroundColor
            self.addSubview(imageView!)
        }
    }
    
    private func removeImageView() {
        self.imageView?.removeFromSuperview()
        self.imageView = nil
    }
    
    private func updateImageView() {
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
    
    private var fittingString: String {
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

    
    public var placeholderString: String? {
        get { textField.placeholderString }
        set { textField.placeholderString = newValue }
    }
    
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

    
    public var paddings = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4) {
        didSet {
            updateActiveConstraints()
        }
    }
    
   public func setEqualPadding(_ value: CGFloat) {
        self.imagePadding = value
        self.paddings =  NSDirectionalEdgeInsets(value)
    }
    
    private var activeLayoutConstraints: [NSLayoutConstraint] = []
    private func updateActiveConstraints() {
        NSLayoutConstraint.deactivate(activeLayoutConstraints)
        var paddings = self.paddings
        paddings.trailing = paddings.trailing * 3.0
        paddings.leading = paddings.leading * 3.0
        if let imageView = imageView {
            switch imagePosition {
            case .leading, .bottom:
                activeLayoutConstraints = [
                imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddings.leading),
                imageView.trailingAnchor.constraint(equalTo: textField.leadingAnchor, constant: -imagePadding),
                textField.topAnchor.constraint(equalTo: self.topAnchor, constant: paddings.top),
                textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -paddings.bottom),
                textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -paddings.trailing),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                imageView.heightAnchor.constraint(equalToConstant: textField.bounds.height*self.imageSizeScaling),
                imageView.centerYAnchor.constraint(equalTo: textField.centerYAnchor),]
                NSLayoutConstraint.activate(activeLayoutConstraints)
            case .trailing, .top:
                activeLayoutConstraints = [
                imageView.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: imagePadding),
                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -paddings.trailing),
                textField.topAnchor.constraint(equalTo: self.topAnchor, constant: paddings.top),
                textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddings.leading),
                textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -paddings.bottom),
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
                textField.topAnchor.constraint(equalTo: self.topAnchor, constant: paddings.top),
                textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddings.leading + capsulePading),
                textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -paddings.bottom),
                textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -paddings.trailing - capsulePading)
            ]
            NSLayoutConstraint.activate(activeLayoutConstraints)
        }
    }
    
    private var capsulePading: CGFloat = 0.0 {
        didSet {
            self.updateActiveConstraints()
        }
    }
    
    public override var wantsUpdateLayer: Bool { true }
    
    convenience init(string: String? = nil, placeholder: String? = nil, color: NSColor = .controlAccentColor, image: NSImage? = nil, height: CGFloat) {
        self.init(string: string)
        self.placeholderString = placeholder
        self.backgroundColor = color
        self.image = image
        self.sizeToFit(height: height)
    }
    
    private let isSelectedAlphaValue: CGFloat = 0.75
    init(string: String? = nil, color: NSColor = .controlAccentColor , paddings: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)) {
        self.paddings = paddings
        super.init(frame: NSRect(x: 0, y: 0, width: 10, height: 10))
        wantsLayer = true
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        self.updateActiveConstraints()
        textField.textColor = self.foregroundColor
        textField.isEditable = false
        NSLayoutConstraint.activate(activeLayoutConstraints)
        self.backgroundColor = color
        if let string = string {
            self.title = string
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var visualEffectView: NSVisualEffectView? = nil
    private func addVisualEffectView() {
        if (self.visualEffectView == nil) {
            self.visualEffectView = NSVisualEffectView()
            self.visualEffectView?.blendingMode = .withinWindow
            self.visualEffectView?.material = .hudWindow
            self.visualEffectView?.state = .followsWindowActiveState
            self.addSubview(withConstraint: self.visualEffectView!)
            self.visualEffectView?.sendToBack()
        }
    }
    
    private func removeVisualEffectView() {
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
        case .visualEffect(let name):
            self.addVisualEffectView()
            let appearance = NSAppearance(named: name)!
            self.visualEffectView?.appearance = appearance
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
