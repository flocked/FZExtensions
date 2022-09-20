
#if os(macOS)

import Cocoa

public class PullRefreshableScrollView: NSScrollView {

    public var accessoryViewHandlers = AccessoryViewHandlers() {
        didSet {  self.accessoryViewsUpdated() }  }
    
    public var updateHandlers = UpdateHandlers()

    @objc public enum ViewEdge : Int {
        case top
        case bottom
    }
    
    internal func viewFor(edge: ViewEdge) -> NSView? {
        switch edge {
        case .top:
            return accessoryViewHandlers.top?()
        case .bottom:
            return accessoryViewHandlers.bottom?()
        }
    }
    
    internal func notify(onEdge edge: ViewEdge, ifNeeded: Bool = true, ofState new: EdgeParameters.P2RState, was oldValue: EdgeParameters.P2RState) {
        if ifNeeded {
            guard new != oldValue else { return }
        }
        switch new {
        case .none:
            self.updateHandlers.didReset?(edge, self.viewFor(edge: edge))
        case .elastic:
            self.updateHandlers.didStart?(edge, self.viewFor(edge: edge))
        case .overpulled:
            self.updateHandlers.didUpdate?(edge, self.viewFor(edge: edge), Double(100))
            self.updateHandlers.didEnterValidationArea?(edge, self.viewFor(edge: edge))
        case .stuck:
            self.updateHandlers.didSucceed?(edge, self.viewFor(edge: edge))
            if let shouldReset = self.accessoryViewHandlers.shouldReset?(.top, self.viewFor(edge: edge)) {
                if shouldReset {
                    params[edge]!.resetScroll()
                }
            }
        }
    }
    
    internal typealias AnyEdgeParameters = EdgeParameters & EdgeScrollBehavior
    
    internal class TopEdgeParameters : EdgeParameters, EdgeScrollBehavior {
        var scrollBaseValue : CGFloat {
            get {
                return 0
            }
        }
      public  var minimumScroll : CGFloat {
            get {
                return self.scrollBaseValue - ((self.accessoryView?.frame.size.height) ?? 0)
            }
        }
        
        public  var isOverThreshold : Bool {
            get {
                let clipView : NSClipView = scrollView!.contentView
                let bounds = clipView.bounds
                
                let scrollValue = bounds.origin.y
                let minimumScroll = self.minimumScroll
                
                return (scrollValue <= minimumScroll)
            }
        }
        public  func resetScroll() {
            if self.viewState == .stuck {
                self.viewState = .none
                
                if (scrollView!.documentVisibleRect.origin.y < 0) {
                    scrollView!.sendScroll(wheel1: 1)
                }
            }
        }
    }
    
    internal class BottomEdgeParameters : EdgeParameters, EdgeScrollBehavior {
        var scrollBaseValue : CGFloat {
            get {
                return (scrollView!.documentView?.frame.height ?? 0)
            }
        }
        var minimumScroll : CGFloat {
            get {
                return ((self.accessoryView?.frame.size.height) ?? 0) + self.scrollBaseValue
            }
        }
        var isOverThreshold : Bool {
            get {
                let clipView : NSClipView = scrollView!.contentView
                let bounds = clipView.bounds
                
                let scrollValue = bounds.maxY
                let minimumScroll = self.minimumScroll
                
                return (scrollValue >= minimumScroll)
            }
        }
        func resetScroll() {
            if self.viewState == .stuck {
                self.viewState = .none
                
                if (scrollView!.documentVisibleRect.maxY > self.scrollBaseValue) {
                    scrollView!.sendScroll(wheel1: -1)
                }
            }
        }
    }
    
    internal lazy var top = TopEdgeParameters(self, edge: .top)
    internal lazy var bottom = BottomEdgeParameters(self, edge: .bottom)
    internal lazy var params : [ViewEdge : EdgeParameters & EdgeScrollBehavior] = [.top : top, .bottom : bottom]
    
    override public func viewDidMoveToWindow() {
        self.verticalScrollElasticity = .allowed
        
        _ = self.contentView // create new content view
        
        self.contentView.postsFrameChangedNotifications = true
        self.contentView.postsBoundsChangedNotifications = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(clipViewBoundsChanged(_:)), name: NSView.boundsDidChangeNotification, object: self.contentView)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollViewFrameChanged(_:)), name: NSView.frameDidChangeNotification, object: self)
        
        self.accessoryViewsUpdated()
    }
    
    internal func accessoryViewsUpdated() {
        placeAccessoryView(self.top.accessoryView, onEdge: .top)
        placeAccessoryView(self.bottom.accessoryView, onEdge: .bottom)
    }

    @objc internal func scrollViewFrameChanged(_ notification: NSNotification) {
        guard let documentView = self.documentView else { return }
        let contentRect = documentView.frame
        
        
        if let view = top.accessoryView {
            view.frame = NSMakeRect(0, contentRect.minY - view.frame.height, contentRect.size.width, view.frame.height)
        }
        
        if let view = bottom.accessoryView {
            view.frame = NSMakeRect(0, contentRect.height, contentRect.size.width, view.frame.height)
        }
    }
    
    @objc internal func clipViewBoundsChanged(_ notification: NSNotification) {
        if top.viewState != .stuck, self.top.enabled {
            let top = self.top.isOverThreshold
            if (top) {
                self.top.viewState = .overpulled
            }
        }
        
        if bottom.viewState != .stuck, self.bottom.enabled {
            let bottom = self.bottom.isOverThreshold
            if (bottom) {
                self.bottom.viewState = .overpulled
            }
        }
    }
    
    private func placeAccessoryView(_ view: NSView?, onEdge edge: ViewEdge) {
       
        guard let view = view else { return }
        guard let documentView = self.documentView else { return }
        
        // add header view to clipview
        let contentRect = documentView.frame
        
        switch edge {
        case .top:
            view.frame = NSMakeRect(0, contentRect.minY - view.frame.height, contentRect.size.width, view.frame.height)
        case .bottom:
            view.frame = NSMakeRect(0, contentRect.height, contentRect.size.width, view.frame.height)
        }
        
        self.contentView.addSubview(view)
        
        // Scroll to top
        self.contentView.scroll(to: NSMakePoint(contentRect.origin.x, 0))
        self.reflectScrolledClipView(self.contentView)
    }
    
    override public func scrollWheel(with theEvent: NSEvent) {
        if theEvent.phase == .began {
            if top.viewState != .stuck && top.enabled && theEvent.scrollingDeltaY > 0 && verticalScroller!.doubleValue == 0 {
                top.viewState = .elastic
            }
            
            if bottom.viewState != .stuck && bottom.enabled && theEvent.scrollingDeltaY < 0 && verticalScroller!.doubleValue == 1 {
                bottom.viewState = .elastic
            }
        }
        
        super.scrollWheel(with: theEvent)
        
        let clipView = self.contentView
        let bounds = clipView.bounds
        
        if top.viewState == .elastic {
            let minimumScroll = abs(self.top.minimumScroll)
            let scrollValue = abs(bounds.origin.y).clamped(0...minimumScroll)
            updateHandlers.didUpdate?(.top, self.viewFor(edge: .top), Double(100*scrollValue/minimumScroll))
        }
        
        if bottom.viewState == .elastic {
            let minimumScroll = abs(self.bottom.minimumScroll) - bounds.size.height
            let scrollValue = abs(bounds.origin.y).clamped(0...minimumScroll)
            let accessoryHeight = bottom.accessoryView?.frame.size.height ?? 0
            let percentage = Double(100*(accessoryHeight - (minimumScroll - scrollValue))/accessoryHeight)
            updateHandlers.didUpdate?(.bottom, self.viewFor(edge: .bottom), percentage)
        }
        
        if (theEvent.phase == .ended) {
            if (self.top.enabled && self.top.isOverThreshold && top.viewState != .stuck)
            {
                self.top.viewState = .stuck
            }
            else if top.viewState != .stuck {
                top.viewState = .none
            }
            
            if (self.bottom.enabled && self.bottom.isOverThreshold && bottom.viewState != .stuck)
            {
                self.bottom.viewState = .stuck
            }
            else if bottom.viewState != .stuck {
                bottom.viewState = .none
            }
        }
        
        if theEvent.momentumPhase == .ended {
            if top.viewState != .stuck {
                top.viewState = .none
            }
            if bottom.viewState != .stuck {
                bottom.viewState = .none
            }
        }
    }
    
    override public var contentView: NSClipView {
        get {
            var superClipView = super.contentView
            if !(superClipView is PullRefreshableClipView) {
                
                // backup the document view
                let documentView = superClipView.documentView
                
                let clipView = PullRefreshableClipView.init(frame: superClipView.frame)
                self.contentView = clipView;
                clipView.documentView = documentView
                
                superClipView = super.contentView
            }
            return superClipView;
        }
        set {
            super.contentView = newValue
        }
    }
    
    private func sendScroll(wheel1: Int32 = 0, wheel2: Int32 = 0) {
        guard let cgEvent = CGEvent.init(scrollWheelEvent2Source: nil, units: CGScrollEventUnit.line, wheelCount: 2, wheel1: wheel1, wheel2: wheel2, wheel3: 0) else { return }
        
        guard let scrollEvent = NSEvent.init(cgEvent: cgEvent) else { return }
        self.scrollWheel(with: scrollEvent)
    }
    
    public func endAction(onEdge edge: ViewEdge) {
        if edge == .top {
            top.resetScroll()
        }
        if edge == .bottom {
            bottom.resetScroll()
        }
    }
    
    public func endActions() {
        top.resetScroll()
        bottom.resetScroll()
    }
}

public extension PullRefreshableScrollView {
   typealias Handler = ((PullRefreshableScrollView.ViewEdge, NSView?)->())
   typealias PercentageHandler = ((PullRefreshableScrollView.ViewEdge, NSView?, Double)->())
   typealias AccessoryViewHandler = (()->(NSView)?)
   typealias HideAccessoryViewHandler = (PullRefreshableScrollView.ViewEdge, NSView?)->Bool
    typealias EndHandler = ((PullRefreshableScrollView.ViewEdge, NSView?, Bool)->())

    
     struct UpdateHandlers {
        public var didReset: Handler? = nil
        public var didStart: Handler? = nil
        public var didEnterValidationArea: Handler? = nil
        public var didUpdate: PercentageHandler? = nil
        public var didSucceed: Handler? = nil
    }
    
     struct AccessoryViewHandlers {
        public var top: AccessoryViewHandler? = nil
        public var bottom: AccessoryViewHandler? = nil
        public var shouldReset: HideAccessoryViewHandler? = nil
    }
}

internal protocol EdgeScrollBehavior {
    var scrollBaseValue : CGFloat { get }
    var minimumScroll : CGFloat { get }
    var isOverThreshold : Bool { get }
    func resetScroll() //sends a scroll event to make the disappearance of the accessory view less brutal
}

internal class EdgeParameters {
    weak var scrollView : PullRefreshableScrollView?
    var edge : PullRefreshableScrollView.ViewEdge
    
    internal enum P2RState {
        case none
        case elastic
        case overpulled
        case stuck
    }
    
    public enum TriggerBehaviour {
        case instant
        case overThreshold
    }
    
    init(_ view: PullRefreshableScrollView, edge myEdge: PullRefreshableScrollView.ViewEdge) {
        scrollView = view
        edge = myEdge
    }
    
    internal var accessoryView : NSView? {
        get {
            return scrollView!.viewFor(edge: self.edge) ?? nil
        }
    }
    
    internal var enabled : Bool {
        get {
            return self.accessoryView != nil
        }
    }
    
    internal var viewState : P2RState = .none {
        didSet {
            scrollView!.notify(onEdge: self.edge, ofState: viewState, was: oldValue)
        }
    }
}

public class PullRefreshableClipView: NSClipView {
    
    override public var isFlipped: Bool {
        get {
            return true
        }
    }
    
    override public var documentRect: NSRect {
        //this expands the scrollable area to include the accessory views, making scrollers match the full scrollable range – scrolling works as usual and feels less clunky
        var docRect = super.documentRect
        if (top.viewState == .stuck) {
            docRect.size.height += (top.accessoryView?.frame.size.height ?? 0)
            docRect.origin.y    -= (top.accessoryView?.frame.size.height ?? 0)
        }
        if (bottom.viewState == .stuck) {
            docRect.size.height += (bottom.accessoryView?.frame.size.height ?? 0)
        }
        return docRect
    }
    
    override public func constrainBoundsRect(_ proposedBounds: NSRect) -> NSRect {// this method determines the "elastic" of the scroll view or how high it can scroll without resistence.
        let proposedNewOrigin = proposedBounds.origin
        var constrained = super.constrainBoundsRect(proposedBounds)
        let scrollValue = proposedNewOrigin.y // this is the y value where the top of the document view is
        let isTopOver = scrollValue <= top.minimumScroll
        let isBottomOver = scrollValue >= top.minimumScroll
        
        if (top.viewState == .stuck && scrollValue <= 0) { // if the accessory view is open
            constrained.origin.y = proposedNewOrigin.y
            if isTopOver { // and if we are scrolled above the refresh view
                //this check ensures that there is no weird effect while scrolling if the accessory view is open
                constrained.origin.y = top.minimumScroll // constrain us to the refresh view
            }
        }
        
        if (bottom.viewState == .stuck && scrollValue >= 0) { // if the accessory view is open
            constrained.size.height = proposedBounds.height
            if isBottomOver { // and if we are scrolled above the refresh view
                //but nothing to do, the documentRect change is enough
            }
        }
        
        return constrained
    }
    
    override public var enclosingScrollView: PullRefreshableScrollView? {
        get {
            return (super.enclosingScrollView as? PullRefreshableScrollView) ?? nil
        }
    }
    
    var top: PullRefreshableScrollView.TopEdgeParameters {
        get {
            return enclosingScrollView!.top
        }
    }
    
    var bottom: PullRefreshableScrollView.BottomEdgeParameters {
        get {
            return enclosingScrollView!.bottom
        }
    }
    
}
#endif
