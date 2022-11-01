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
    public init(_ class_: AnyClass, @SwizzleFunctionBuilder _ makeSwizzlePairs: () -> [SwizzlePair]) {
        let swizzlePairs = makeSwizzlePairs()
        for swizzlePair in swizzlePairs {
            swizzleMethods(class_, swizzlePair)
        }
    }
    
    @discardableResult
    public init(_ class_: AnyClass, @SwizzleFunctionBuilder _ makeSwizzlePairs: () -> SwizzlePair) {
        let swizzlePair = makeSwizzlePairs()
        swizzleMethods(class_, swizzlePair)
    }
    
    internal func swizzleMethods(_ class_: AnyClass, _ swizzlePairs: [SwizzlePair], isClassMethod: Bool) {
        for swizzlePair in swizzlePairs {
            self.swizzleMethods(class_, swizzlePair, isClassMethod: isClassMethod)
        }
    }
     /*
   public static func check(_ class_: AnyClass, @SwizzleFunctionBuilder _ makeSwizzlePairs: () -> SwizzlePair) -> Bool {
        let swizzlePair = makeSwizzlePairs()
        return self.checkMethod(class_, swizzlePair)
    }
    
   public static func check(_ class_: AnyClass, @SwizzleFunctionBuilder _ makeSwizzlePairs: () -> [SwizzlePair]) -> Bool {
        let swizzlePairs = makeSwizzlePairs()
        for swizzlePair in swizzlePairs {
            if (self.checkMethod(class_, swizzlePair)) {
                return true
            }
        }
        return false
    }
    
    internal static func checkMethod(_ class_: AnyClass, _ swizzlePairs: SwizzlePair, isClassMethod: Bool? = nil) -> Bool {
        let selector1 = swizzlePairs.original
        let selector2 = swizzlePairs.swizzled
        
        let isClassMethod = isClassMethod ?? class_.responds(to: swizzlePairs.original)
        
        let c: AnyClass
        if isClassMethod {
            guard let c_ = object_getClass(class_) else {
                return false
            }
            c = c_
        }
        else {
            c = class_
        }

        guard let method1: Method = class_getInstanceMethod(c, selector1),
            let method2: Method = class_getInstanceMethod(c, selector2) else
        {
            return false
        }

        return !class_addMethod(c, selector1, method_getImplementation(method2), method_getTypeEncoding(method2))
    }
    */
    
    internal func swizzleMethods(_ class_: AnyClass, _ swizzlePairs: SwizzlePair, isClassMethod: Bool? = nil) {
        let selector1 = swizzlePairs.original
        let selector2 = swizzlePairs.swizzled
        
        let isClassMethod = isClassMethod ?? class_.responds(to: swizzlePairs.original)
        
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
}
