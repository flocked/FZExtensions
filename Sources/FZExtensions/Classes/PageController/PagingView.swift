//
//  PagingView.swift
//  PageController
//
//  Created by Florian Zand on 26.05.22.
//

#if os(macOS)
import Foundation
import AppKit

class PagingView<View: NSView, Element>: NSView {
    private typealias ViewController = TypedViewController<View>
    typealias Handler = ((View, Element)->())

   private let pageController: PageController<ViewController, Element>

    
    func select(_ index: Int, duration: CGFloat = 0.0) {
        pageController.select(index, duration: duration)
    }
    
    func advance(to type: NSPageController.AdvanceType, duration: CGFloat = 0.0) {
        pageController.advance(to: type, duration: duration)
    }
    
    var transitionStyle: NSPageController.TransitionStyle {
        get { pageController.transitionStyle }
        set {  pageController.transitionStyle = newValue } }
    
    var keyControllable: NSPageController.KeyboardControl {
        get { pageController.keyboardControl }
        set { pageController.keyboardControl = newValue } }
    
    var swipeControllable: Bool {
        get {  pageController.isSwipeable }
        set { pageController.isSwipeable = newValue } }
    
    var selectedIndex: Int {
        get { return pageController.selectedIndex }
        set { pageController.selectedIndex = newValue } }
    
    var elements: [Element] {
        get { return pageController.elements }
        set { pageController.elements = newValue } }
    
    init(frame: CGRect, elements: [Element] = [], handler: @escaping Handler) {
        self.pageController = PageController<ViewController, Element>(handler: {
            viewController, element in
            handler(viewController.typedView, element)
        })
        self.pageController.elements = elements
        super.init(frame: frame)
        self.addSubview(withConstraint: pageController.view)
    }
    
    convenience init(elements: [Element] = [], handler: @escaping Handler) {
          self.init(frame: .zero, elements: elements, handler: handler)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TypedViewController<View: NSView>: NSViewController {
    override func loadView() {
        self.view = View()
    }
    var typedView: View {
        return self.view as! View
    }
}
#endif
