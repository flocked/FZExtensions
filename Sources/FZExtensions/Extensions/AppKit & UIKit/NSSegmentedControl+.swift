//
//  NSSegmentedControl+.swift
//  FZExtensions
//
//  Created by Florian Zand on 18.08.22.
//

#if os(macOS)

import AppKit

public extension NSSegmentedControl {
    struct Segment: Equatable, ExpressibleByStringLiteral {
        public typealias StringLiteralType = String
 
        internal weak var segmentedControl: NSSegmentedControl?
        var title: String? {
            didSet { segmentedControl?.update(self)  } }
        var image: NSImage? {
            didSet { segmentedControl?.update(self)  } }
        var isSelected: Bool {
            didSet { segmentedControl?.update(self)  } }
        
       public init(title: String?, image: NSImage?, isSelected: Bool) {
            self.title = title
            self.image = image
            self.isSelected = isSelected
            self.segmentedControl = nil
        }
        
        public init(title: String) {
             self.title = title
             self.image = nil
             self.isSelected = false
             self.segmentedControl = nil
         }
        
        public init(image: NSImage) {
             self.title = nil
             self.image = image
             self.isSelected = false
             self.segmentedControl = nil
         }
        
        public init(title: String, isSelected: Bool) {
             self.title = title
             self.image = nil
             self.isSelected = isSelected
             self.segmentedControl = nil
         }
        
        public init(image: NSImage, isSelected: Bool) {
             self.title = nil
             self.image = image
             self.isSelected = isSelected
             self.segmentedControl = nil
         }
        
        public init(stringLiteral value: String) {
            self.title = value
            self.isSelected = false
            self.image = nil
            self.segmentedControl = nil
        }
        
        internal init(title: String?, image: NSImage?, isSelected: Bool, segmentedControl: NSSegmentedControl?) {
             self.title = title
             self.image = image
             self.isSelected = isSelected
             self.segmentedControl = segmentedControl
         }
    }
    
    convenience init(frame: CGRect, segments: [Segment]) {
        self.init(frame: frame)
        self.segments = segments
    }
    
    convenience init(segments: [Segment]) {
        self.init(frame: .zero)
        self.segments = segments
    }
    
    var segments: [Segment] {
        get {
            let count = self.segmentCount - 1
            var segments: [Segment] = []
            for index in 0...count {
                let segment = Segment(title: self.label(forSegment: index), image: self.image(forSegment: index), isSelected: self.isSelected(forSegment: index), segmentedControl: self)
                segments.append(segment)
            }
            return segments
        }
        set {
            
            self.segmentCount = newValue.count
            for (index, segment) in newValue.enumerated() {
                var segment = segment
                segment.segmentedControl = self
                self.setLabel(segment.title ?? "", forSegment: index)
                self.setImage(segment.image, forSegment: index)
                self.setSelected(segment.isSelected, forSegment: index)
            }
        }
    }
    
    func segment(titled title: String) -> Segment? {
        return self.segments.first(where: {$0.title == title})
    }

    func index(of segment: Segment) -> Int? {
        return self.segments.firstIndex(of: segment)
    }
    
    func selectAll() {
        let count = self.segmentCount - 1
        for index in 0...count {
            self.setSelected(true, forSegment: index)
        }
    }
    
    func deselectAll() {
        let count = self.segmentCount - 1
        for index in 0...count {
            self.setSelected(false, forSegment: index)
        }
    }
    
   internal func update(_ segment: Segment) {
    if let index = self.index(of: segment) {
        self.setLabel(segment.title ?? "", forSegment: index)
        self.setImage(segment.image, forSegment: index)
        self.setSelected(segment.isSelected, forSegment: index)
        }
    }
                
    func isSelected(for title: String) -> Bool {
        return self.segment(titled: title)?.isSelected ?? false
    }
}

public extension NSSegmentedControl {
  func selectSegment(named name: String) {
    self.selectedSegment = -1
    for i in 0..<segmentCount {
      if self.label(forSegment: i) == name {
        self.selectedSegment = i
      }
    }
  }
}

#endif
