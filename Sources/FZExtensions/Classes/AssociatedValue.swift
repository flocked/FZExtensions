//
//  AddProperties.swift
//  GifAnim
//
//  Created by Florian Zand on 31.05.22.
//

import Foundation
import ObjectiveC.runtime

public func getAssociatedValue<T>(key: String, object: AnyObject) -> T? {
    return (objc_getAssociatedObject(object, key.address) as? AssociatedValue)?.value as? T
}

public func getAssociatedValue<T>(key: String, object: AnyObject, initialValue: @autoclosure () -> T) -> T {
    return getAssociatedValue(key: key, object: object) ?? setAndReturn(initialValue: initialValue(), key: key, object: object)
}

public func getAssociatedValue<T>(key: String, object: AnyObject, initialValue: () -> T) -> T {
    return getAssociatedValue(key: key, object: object) ?? setAndReturn(initialValue: initialValue(), key: key, object: object)
}

fileprivate func setAndReturn<T>(initialValue: T, key: String, object: AnyObject) -> T {
    set(associatedValue: initialValue, key: key, object: object)
    return initialValue
}

public func set<T>(associatedValue: T?, key: String, object: AnyObject) {
    set(associatedValue: AssociatedValue(associatedValue), key: key, object: object)
}

public func set<T : AnyObject>(weakAssociatedValue: T?, key: String, object: AnyObject) {
    set(associatedValue: AssociatedValue(weak: weakAssociatedValue), key: key, object: object)
}

extension String {
    fileprivate var address: UnsafeRawPointer {
        return UnsafeRawPointer(bitPattern: abs(hashValue))!
    }
}

private func set(associatedValue: AssociatedValue, key: String, object: AnyObject) {
    objc_setAssociatedObject(object, key.address, associatedValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

private class AssociatedValue {
    
    weak var _weakValue: AnyObject?
    var _value: Any?
    
    var value: Any? {
        return _weakValue ?? _value
    }
    
    init(_ value: Any?) {
        _value = value
    }
    
    init(weak: AnyObject?) {
        _weakValue = weak
    }
    
}

/*

private class AssociatedArrayValue {
    
    weak var _weakValue: [AnyObject]?
    var _value: [Any]?
    
    var value: [Any]? {
        return _weakValue ?? _value
    }
    
    init(_ value: [Any]?) {
        _value = value
    }
    
    init(weak: [AnyObject]?) {
        _weakValue = weak
    }
    
}
*/

/*extension UIImageView: GIFAnimatable {
 private struct AssociatedKeys {
   static var AnimatorKey = "gifu.animator.key"
 }

 override open func display(_ layer: CALayer) {
   updateImageIfNeeded()
 }

 public var animator: Animator? {
   get {
     guard let animator = objc_getAssociatedObject(self, &AssociatedKeys.AnimatorKey) as? Animator else {
       let animator = Animator(withDelegate: self)
       self.animator = animator
       return animator
     }

     return animator
   }

   set {
     objc_setAssociatedObject(self, &AssociatedKeys.AnimatorKey, newValue as Animator?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
   }
 }
}*/
