//
//  Swizzle.swift
//  FZCollection
//
//  Created by Florian Zand on 05.06.22.
//

import Foundation

infix operator <->

public struct SwizzlePair {
    let original: Selector
    let swizzled: Selector
}

extension Selector {
    
    public static func <->(original: Selector, swizzled: Selector) -> SwizzlePair {
        SwizzlePair(original: original, swizzled: swizzled)
    }
    
}

public struct Swizzle {

    @resultBuilder
    public struct SwizzleFunctionBuilder {
        
        public static func buildBlock(_ swizzlePairs: SwizzlePair...) -> [SwizzlePair] {
            Array(swizzlePairs)
        }
        
    }
    
    @discardableResult
    public init(_ type: AnyObject.Type, @SwizzleFunctionBuilder _ makeSwizzlePairs: () -> [SwizzlePair]) {
        let swizzlePairs = makeSwizzlePairs()
        swizzle(type: type, pairs: swizzlePairs)
    }
    
    @discardableResult
    public init(_ type: AnyObject.Type, @SwizzleFunctionBuilder _ makeSwizzlePairs: () -> SwizzlePair) {
        let swizzlePairs = makeSwizzlePairs()
        swizzle(type: type, pairs: [swizzlePairs])
    }
    
    private func swizzle(type: AnyObject.Type, pairs: [SwizzlePair]) {
        pairs.forEach { swizzlePair in
             guard
                 let originalMethod = class_getInstanceMethod(type, swizzlePair.original),
                 let swizzledMethod = class_getInstanceMethod(type, swizzlePair.swizzled)
                 else { return }
             method_exchangeImplementations(originalMethod, swizzledMethod)
         }
    }
    
    @discardableResult
    public init(class_: AnyClass, @SwizzleFunctionBuilder _ makeSwizzlePairs: () -> [SwizzlePair]) {
        let swizzlePairs = makeSwizzlePairs()
        self.swizzleInstanceMethod(class_, paris: swizzlePairs)
    }
    
    @discardableResult
    public init(class_: AnyClass, @SwizzleFunctionBuilder _ makeSwizzlePairs: () -> SwizzlePair) {
        let swizzlePairs = makeSwizzlePairs()
        self.swizzleInstanceMethod(class_, paris: [swizzlePairs])
    }
    
 
    public func swizzleInstanceMethod(_ class_: AnyClass, paris: [SwizzlePair])
    {
        _swizzleMethod(class_, pairs: paris, isClassMethod: false)
    }

    /// Class-method swizzling.
    public func swizzleClassMethod(_ class_: AnyClass, paris: [SwizzlePair]) {
        _swizzleMethod(class_, pairs: paris, isClassMethod: true)
    }
    
    private func _swizzleMethod(_ class_: AnyClass, pairs: [SwizzlePair], isClassMethod: Bool) {
        let c: AnyClass
        if isClassMethod {
            guard let c_ = object_getClass(class_) else {
                return
            }
            c = c_
        }
        else {
            c = class_
        }
        pairs.forEach { swizzlePair in
            guard let method1: Method = class_getInstanceMethod(c, swizzlePair.original),
                  let method2: Method = class_getInstanceMethod(c, swizzlePair.swizzled) else
            {
                return
            }

            if class_addMethod(c, swizzlePair.original, method_getImplementation(method2), method_getTypeEncoding(method2)) {
                class_replaceMethod(c, swizzlePair.swizzled, method_getImplementation(method1), method_getTypeEncoding(method1))
            }
            else {
                method_exchangeImplementations(method1, method2)
            }
            
            
         }
    }
    
}



/*
import ObjectiveC

private func _swizzleMethod(_ class_: AnyClass, from selector1: Selector, to selector2: Selector, isClassMethod: Bool)
{
    let c: AnyClass
    if isClassMethod {
        guard let c_ = object_getClass(class_) else {
            return
        }
        c = c_
    }
    else {
        c = class_
    }

    guard let method1: Method = class_getInstanceMethod(c, selector1),
        let method2: Method = class_getInstanceMethod(c, selector2) else
    {
        return
    }

    if class_addMethod(c, selector1, method_getImplementation(method2), method_getTypeEncoding(method2)) {
        class_replaceMethod(c, selector2, method_getImplementation(method1), method_getTypeEncoding(method1))
    }
    else {
        method_exchangeImplementations(method1, method2)
    }
}

/// Instance-method swizzling.
public func swizzleInstanceMethod(_ class_: AnyClass, from sel1: Selector, to sel2: Selector)
{
    _swizzleMethod(class_, from: sel1, to: sel2, isClassMethod: false)
}

/// Instance-method swizzling for unsafe raw-string.
/// - Note: This is useful for non-`#selector`able methods e.g. `dealloc`, private ObjC methods.
public func swizzleInstanceMethodString(_ class_: AnyClass, from sel1: String, to sel2: String)
{
    swizzleInstanceMethod(class_, from: Selector(sel1), to: Selector(sel2))
}

/// Class-method swizzling.
public func swizzleClassMethod(_ class_: AnyClass, from sel1: Selector, to sel2: Selector)
{
    _swizzleMethod(class_, from: sel1, to: sel2, isClassMethod: true)
}

/// Class-method swizzling for unsafe raw-string.
public func swizzleClassMethodString(_ class_: AnyClass, from sel1: String, to sel2: String)
{
    swizzleClassMethod(class_, from: Selector(sel1), to: Selector(sel2))
}
*/
