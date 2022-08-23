
#if os(macOS)

import AppKit

public class RatingView : NSView {
    // star.fill.left
    // star.slash.fill
    // star.slash
    //star.circle.fill
    // star.square.fill
    
    public var rating = 0
    public var maxRating:Int = 5
    private var initialRating:Int = 0
    public var size:CGFloat = 14
    
    public var halfSteps = false
    
    public var onColor: NSColor = .black {
        didSet { resetImages() } }

    public var offColor: NSColor? = nil {
        didSet { resetImages() } }
    
    private func resetImages() {
        Self._offImage = nil
        Self._onImage = nil
        Self._halfImage = nil
        self.needsDisplay = true
    }

    
    public var isEnabled:Bool = true {
        didSet {
            self.layer?.opacity = isEnabled ? 1.0 : 0.33 }
    }
    
    public override var intrinsicContentSize: NSSize {
        guard !isHidden else { return .zero }
        return CGSize(CGFloat(maxRating)*size,size)
    }
    
    public override var isHidden: Bool {
        didSet { self.invalidateIntrinsicContentSize() }
    }

    public override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        Self._offImage = nil
        Self._onImage = nil
    }
    
    private var offImage:NSImage? {
        if Self._offImage == nil {
            Self._offImage = Self.image(systemName:"star", color: self.offColor ?? self.onColor) }
        return Self._offImage
    }
    
    private static var _offImage:NSImage? = nil

    private var onImage:NSImage? {
        if Self._onImage == nil {
            Self._onImage = Self.image(systemName:"star.fill", color: self.onColor)
        }
        return Self._onImage
    }
    
    private static var _onImage:NSImage? = nil
    
    private var halfImage:NSImage? {
        if Self._halfImage == nil {
            Self._halfImage = Self.image(systemName:"star.fill.left", color: self.onColor)
        }
        return Self._halfImage
    }
    
    private static var _halfImage:NSImage? = nil
    
    class func image(systemName:String, color:NSColor) -> NSImage? {
        if #available(macOS 11, *) {
            guard let icon = NSImage(systemSymbolName:systemName, accessibilityDescription:nil) else { return nil }
            guard let image = icon.copy() as? NSImage else { return nil }
            
            image.lockFocus()
            defer { image.unlockFocus() }
            
            color.set()
            let bounds = NSRect(origin:.zero, size:image.size)
            bounds.fill(using:.sourceAtop)
                
            return image
        }
        else {
            return nil
        }
    }

    public  override func draw(_ rect:NSRect) {
        var frame = CGRect(x:0, y:0, width:size, height:size)
        for i in 1...maxRating {
            frame.origin.x = CGFloat(i-1) * size
            frame.origin.y = bounds.maxY - size
            let image = i <= rating ? onImage : offImage
            image?.draw(in:frame)
        }
    }
    
    public  override func mouseDown(with event:NSEvent){
        guard isEnabled else { return }
        self.initialRating = self.rating
        self.setRating(with:mouse(for:event))
    }
    
    public   override func mouseDragged(with event:NSEvent) {
        guard isEnabled else { return }
        self.setRating(with:mouse(for:event))
    }
    
    public  override func mouseUp(with event:NSEvent) {
        guard isEnabled else { return }
        self.setRating(with:mouse(for:event), isMouseUp:true)
    }

    func mouse(for event:NSEvent) -> CGPoint {
        let mouse = event.locationInWindow
        return self.convert(mouse, from:nil)
    }
  
    func setRating(with mouse:CGPoint, isMouseUp:Bool = false) {
        let x = mouse.x + size
        var i = Int(x/size)
        
        if isMouseUp && i == initialRating         // If new rating is same as on mouseDown, then reset to 0.
        {                                        // That way clicking the same star toggles.
            i = 0
        }
        
        self.rating = i
        self.needsDisplay = true
    }
}

#endif
