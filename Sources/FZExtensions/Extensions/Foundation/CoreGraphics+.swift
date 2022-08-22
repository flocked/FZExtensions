import CoreGraphics

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(lhs.x - rhs.x, lhs.y - rhs.y)
}

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(lhs.x + rhs.x, lhs.y + rhs.y)
}

extension CGRect {
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init(x: x, y: y, width: width, height: height)
    }
    
    init(_ origin: CGPoint, _ size: CGSize) {
        self.init(origin: origin, size: size)
    }
    
    init(size: CGSize) {
        self.init(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    var center: CGPoint {
      get { return CGPoint(x: centerX, y: centerY) }
      set { centerX = newValue.x; centerY = newValue.y }
    }
    
    var bottomLeft: CGPoint {
        get { return CGPoint(x: self.minX, y: self.minY) }
    }
    
    var bottomRight: CGPoint {
        get { return CGPoint(x: self.maxX, y: self.minY) }
    }
    
    var topLeft: CGPoint {
        get { return CGPoint(x: self.minX, y: self.maxY) }
    }
    
    var topRight: CGPoint {
        get { return CGPoint(x: self.maxX, y: self.maxY) }
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
}

extension CGSize {
    init(_ width: CGFloat, _ height: CGFloat) {
       self.init(width: width, height: height)
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

extension CGPoint {
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
}
