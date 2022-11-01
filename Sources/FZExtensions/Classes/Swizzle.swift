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
            if (class_.responds(to: swizzlePair.original)) {
                swizzleMethods(class_, swizzlePair, isClassMethod: true)
            } else {
                swizzleMethods(class_, swizzlePair, isClassMethod: false)
            }
        }
    }
    
    @discardableResult
    public init(_ class_: AnyClass, @SwizzleFunctionBuilder _ makeSwizzlePairs: () -> SwizzlePair) {
        let swizzlePair = makeSwizzlePairs()
        if (class_.responds(to: swizzlePair.original)) {
            swizzleMethods(class_, swizzlePair, isClassMethod: true)
        } else {
            swizzleMethods(class_, swizzlePair, isClassMethod: false)
        }
    }
    
    internal func swizzleMethods(_ class_: AnyClass, _ swizzlePairs: [SwizzlePair], isClassMethod: Bool) {
        for swizzlePair in swizzlePairs {
            self.swizzleMethods(class_, swizzlePair, isClassMethod: isClassMethod)
        }
    }
    
    internal func swizzleMethods(_ class_: AnyClass, _ swizzlePairs: SwizzlePair, isClassMethod: Bool) {
        let selector1 = swizzlePairs.original
        let selector2 = swizzlePairs.swizzled

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
