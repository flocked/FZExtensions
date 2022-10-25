import CoreGraphics

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(lhs.x - rhs.x, lhs.y - rhs.y)
}

public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(lhs.x + rhs.x, lhs.y + rhs.y)
}

public extension CGRect {
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init(x: x, y: y, width: width, height: height)
    }
    
    init(_ origin: CGPoint, _ size: CGSize) {
        self.init(origin: origin, size: size)

    }
    
    init(size: CGSize) {
        self.init(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    init(aroundPoint point: CGPoint, size: CGSize, integralized: Bool = false) {
        let unintegralizedRect = CGRect(x: point.x - size.width / 2.0, y: point.y - size.height / 2.0, width: size.width, height: size.height)
        let result = integralized ? unintegralizedRect.scaledIntegral : unintegralizedRect
        self.init(x: result.origin.x, y: result.origin.y, width: result.size.width, height: result.size.height)
    }
    
    var scaledIntegral: CGRect {
        CGRect(
            x: origin.x.scaledIntegral,
            y: origin.y.scaledIntegral,
            width: size.width.scaledIntegral,
            height: size.height.scaledIntegral
        )
    }
    
    var center: CGPoint {
        get { return CGPoint(x: centerX, y: centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }
    
    var bottomLeft: CGPoint {
        get { return CGPoint(x: self.minX, y: self.minY) }
        set {  self.origin = newValue }
    }
    
    var bottomRight: CGPoint {
        get { return CGPoint(x: self.maxX, y: self.minY) }
    }
    
    var topLeft: CGPoint {
        get { return CGPoint(x: self.minX, y: self.maxY) }
        set {  self.origin = CGPoint(x: newValue.x, y: self.origin.y)
            let width = self.origin.y - newValue.y
            if (width < 0) {
                self.origin = CGPoint(x: self.origin.x, y: self.origin.y-width)
            }
            self.width = self.origin.y + width
        }
    }
    
    var topRight: CGPoint {
        get { return CGPoint(x: self.maxX, y: self.maxY) }
        set {  self.origin = CGPoint(x: newValue.x, y: self.origin.y)
            let width = self.origin.y - newValue.y
            let height = self.origin.x - newValue.x
            if (width < 0) {
                self.origin = CGPoint(x: self.origin.x, y: self.origin.y-width)
            }
            self.width = self.origin.y + width
            if (height < 0) {
                self.origin = CGPoint(x: self.origin.x-height, y: self.origin.y)
            }
            self.height = self.origin.x + height
        }
    }
    
    private var centerX: CGFloat {
        get { return midX }
        set { origin.x = newValue - width * 0.5 }
    }
    
    private var centerY: CGFloat {
        get { return midY }
        set { origin.y = newValue - height * 0.5 }
    }
    
    var x: CGFloat {
        get { self.origin.x }
        set {
            var origin = self.origin
            origin.x = newValue
            self.origin = origin }
    }
    
    var y: CGFloat {
        get { self.origin.y }
        set {
            var origin = self.origin
            origin.y = newValue
            self.origin = origin }
    }
    
    var width: CGFloat {
        get { self.size.width }
        set {
            var size = self.size
            size.width = newValue
            self.size = size }
    }
    
     var height: CGFloat {
        get { self.size.height }
        set {
            var size = self.size
            size.height = newValue
            self.size = size }
    }
    
    
    enum ExpandEdge {
        case minXEdge
        case maxXEdge
        case minYEdge
        case maxYEdge
        case centerWidth
        case centerHeight
        case center
    }
    
    func expanded(_ amount: CGFloat, edge: ExpandEdge) -> CGRect {
        switch edge {
        case .minXEdge:
            return CGRect(x: minX - amount, y: minY, width: width + amount, height: height)
        case .maxXEdge:
            return CGRect(x: minX, y: minY, width: width + amount, height: height)
        case .minYEdge:
            return CGRect(x: minX, y: minY - amount, width: width, height: height + amount)
        case .maxYEdge:
            return CGRect(x: minX, y: minY, width: width, height: height + amount)
        case .center:
            let widthAmount = amount / 2.0
            let heightAmount = amount / 2.0
            return CGRect(x: minX - widthAmount, y: minY - heightAmount, width: width + widthAmount, height: height + heightAmount)
        case .centerWidth:
            let widthAmount = amount / 2.0
            return CGRect(x: minX - widthAmount, y: minY, width: width + widthAmount, height: height)
        case .centerHeight:
            let heightAmount = amount / 2.0
            return CGRect(x: minX , y: minY - heightAmount, width: width , height: height + heightAmount)
        }
    }
    
    func scaled(byFactor factor: CGFloat, centered: Bool = true) -> CGRect {
        var rect = self
        rect.size = rect.size.scaled(byFactor: factor)
        if (centered) {
            rect.center = self.center
        }
        return rect
    }
    
    func scaled(toFit size: CGSize, centered: Bool = true) -> CGRect {
        var rect = self
        rect.size = rect.size.scaled(toFit: size)
        if (centered) {
            rect.center = self.center
        }
        return rect
    }
    
    func scaled(toFill size: CGSize, centered: Bool = true) -> CGRect {
        var rect = self
        rect.size = rect.size.scaled(toFill: size)
        if (centered) {
            rect.center = self.center
        }
        return rect
    }
    
    
    func scaled(toWidth newWidth: CGFloat) -> CGRect {
        let scale = newWidth / self.width
        let newHeight = self.height * scale
        var rect = self
        rect.width = newWidth
        rect.height = newHeight
        return rect
    }
    
    func scaled(toHeight newHeight: CGFloat) -> CGRect {
        let scale = newHeight / self.height
        let newWidth = self.width * scale
        var rect = self
        rect.width = newWidth
        rect.height = newHeight
        return rect
    }
}

public extension CGSize {
    init(_ width: CGFloat, _ height: CGFloat) {
        self.init(width: width, height: height)
    }
    
    var scaledIntegral: CGSize {
        CGSize(width: width.scaledIntegral, height: height.scaledIntegral)
    }
    
    var aspectRatio: CGFloat {
        if height == 0 { return 1 }
        return width / height
    }
    
    func rounded() -> CGSize {
        return CGSize(width: self.width.rounded(), height: self.height.rounded())
    }
    
    func scaled(toWidth newWidth: CGFloat) -> CGSize {
        let scale = newWidth / self.width
        let newHeight = self.height * scale
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func scaled(toHeight newHeight: CGFloat) -> CGSize {
        let scale = newHeight / self.height
        let newWidth = self.width * scale
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func scaled(byFactor factor: CGFloat) -> CGSize {
        return CGSize(width: self.width*factor, height: self.height*factor)
    }
    
    func scaled(toFit innerRect: CGSize) -> CGSize {
        let outerRect = self
        
        // the width and height ratios of the rects
        let wRatio = outerRect.width / innerRect.width
        let hRatio = outerRect.height / innerRect.height
        
        // calculate scaling ratio based on the smallest ratio.
        let ratio = (wRatio > hRatio) ? wRatio : hRatio
        
        // aspect fitted origin and size
        return CGSize(
            width: outerRect.width / ratio,
            height: outerRect.height / ratio
        )
    }
    
    func scaled(toFill innerRect: CGSize) -> CGSize {
        let outerRect = self
        
        // the width and height ratios of the rects
        let wRatio = outerRect.width / innerRect.width
        let hRatio = outerRect.height / innerRect.height
        
        // calculate scaling ratio based on the smallest ratio.
        let ratio = (wRatio < hRatio) ? wRatio : hRatio
        
        // aspect fitted origin and size
        return CGSize(
            width: outerRect.width / ratio,
            height: outerRect.height / ratio
        )
    }
}

public extension CGPoint {
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init(x: x, y: y)
    }
    
    func offset(by offset: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + offset.x, y: self.y + offset.y)
    }
    
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
    
    func distance(to point: CGPoint) -> CGFloat {
        let xdst = self.x - point.x
        let ydst = self.y - point.y
        return sqrt((xdst * xdst) + (ydst * ydst))
    }
    
    
    var scaledIntegral: CGPoint {
        CGPoint(x: x.scaledIntegral, y: y.scaledIntegral)
    }
}

extension CGRect: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.size)
        hasher.combine(self.origin)
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.width)
        hasher.combine(self.height)
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}
