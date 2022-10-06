//
//  File.swift
//  
//
//  Created by Florian Zand on 06.10.22.
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@available(macOS 11.0, iOS 13.0, *)
public extension NSUIHostingController {
    convenience init(rootView: Content, ignoreSafeArea: Bool) {
        self.init(rootView: rootView)
        
        if ignoreSafeArea {
            disableSafeAreaInsets(true)
        }
    }
    
    func disableSafeAreaInsets(_ disable: Bool) {
        self.setSafeAreaInsets((disable == true) ? .zero : nil)
    }
    
   internal func setSafeAreaInsets(_ newSafeAreaInsets: NSUIEdgeInsets?) {
        guard let viewClass = object_getClass(view) else { return }
        
        let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoreSafeArea")
        if let viewSubclass = NSClassFromString(viewSubclassName) {
            object_setClass(view, viewSubclass)
        }
        else {
            guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
            guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }
                        
            if let method = class_getInstanceMethod(NSUIView.self, #selector(getter: NSUIView.safeAreaInsets)) {
                let safeAreaInsets: @convention(block) (AnyObject) -> NSUIEdgeInsets = { view in
                    return newSafeAreaInsets ?? .zero
                }
                
                if (newSafeAreaInsets != nil) {
                    class_addMethod(viewSubclass, #selector(getter: NSUIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
                } else {
                    class_replaceMethod(viewSubclass, #selector(getter: NSUIView.safeAreaInsets), method_getImplementation(method), method_getTypeEncoding(method))
                }
            }
            
            objc_registerClassPair(viewSubclass)
            object_setClass(view, viewSubclass)
        }
    }
}
