//
//  GenericPageController.swift
//  PageController
//
//  Created by Florian Zand on 26.05.22.
//

#if os(macOS)
import Foundation
import AppKit

public class PageController<ViewController: NSViewController, Element>: NSPageController, NSPageControllerDelegate {
    public   override func loadView() {
       self.view = NSView()
     }
    
    var isSwipeable = true
    var isLooping = false
    var keyboardControl: KeyboardControl = .on()

    typealias Handler = ((ViewController, Element)->())
    private let handler: Handler
    
    init(elements: [Element] = [], handler: @escaping Handler) {
        self.handler = handler
        super.init(nibName: nil, bundle: nil)
        self.elements = elements
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    public override func performKeyEquivalent(with event: NSEvent) -> Bool {
        var type: AdvanceType? = nil
        if (event.keyCode == 123) {
            if (event.modifierFlags.contains(.command)) {
                type = .first
            } else {
                type = .previous
            }
        } else {
            if (event.modifierFlags.contains(.command)) {
                type = .last
            } else {
                type = .next
            }
        }
        if let type = type, let values = keyboardControl.values(for: type) {
            self.advance(to: values.0, duration: values.1)
            return true
        }
        return false
    }
    
    public  override var acceptsFirstResponder: Bool {
        return true
    }

    public  override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.transitionStyle = .horizontalStrip
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            let isHandled = self.performKeyEquivalent(with: event)
             //  self.keyDown(with: $0)
            return isHandled ? nil : event
        }
    }

    public  override func scrollWheel(with event: NSEvent) {
        if (isSwipeable) {
            super.scrollWheel(with: event)
        }
    }
    
    var elements: [Element] {
        get {  return self.arrangedObjects.isEmpty ? [] : (self.arrangedObjects as! [Element]) }
        set { self.arrangedObjects = newValue } }
    
    public func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: String) -> NSViewController {
       return ViewController()
    }
    
    public  func pageController(_ pageController: NSPageController, identifierFor object: Any) -> String {
        return "ViewController"
    }
    
    func prepare(viewController: ViewController, with element: Element) {
        handler(viewController, element)
    }
    
    public  func pageController(_ pageController: NSPageController, prepare viewController: NSViewController, with object: Any?) {
        guard let element = object as? Element, let itemVC = viewController as? ViewController else { return }
        self.prepare(viewController: itemVC, with: element)
    }
    
    public  func pageControllerDidEndLiveTransition(_ pageController: NSPageController) {
        self.completeTransition()
    }
}
#endif
