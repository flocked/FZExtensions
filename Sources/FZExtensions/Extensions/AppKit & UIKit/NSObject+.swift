//
//  File.swift
//  
//
//  Created by Florian Zand on 10.10.22.
//

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension NSObject {
    func copyObject() throws -> Self? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Self
    }
    
    func containsValue(named: String) -> Bool {
        self.variableNames().contains(named)
    }
    
    func setValueSafely(_ value: Any?, forKey key: String) {
        if (self.containsValue(named: key)) {
            self.setValue(value, forKey: key)
        }
    }

    func value<T>(forKey key: String, type: T.Type) -> T? {
         if (self.containsValue(named: key)) {
            return self.value(forKey: key) as? T
         }
         return nil
     }
    
    func variableNames() -> [String] {
        let classType = type(of: self)
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass = class_copyPropertyList(classType, &propertiesCount)
        var attributeKeys = [String]()
        for i in 0 ..< Int(propertiesCount) {
           if let property = propertiesInAClass?[i],
              let strKey = NSString(utf8String: property_getName(property)) as String? {
               attributeKeys.append(strKey)
           }
        }
        return attributeKeys
    }

    func dictRepresentation() -> [String: Any?] {
        let classType = type(of: self)
       var propertiesCount : CUnsignedInt = 0
       let propertiesInAClass = class_copyPropertyList(classType, &propertiesCount)
       var propertiesDictionary = [String:Any?]()

       for i in 0 ..< Int(propertiesCount) {
          if let property = propertiesInAClass?[i],
             let strKey = NSString(utf8String: property_getName(property)) as String? {
               propertiesDictionary[strKey] = value(forKey: strKey)
          }
       }
       return propertiesDictionary
   }
    
    func overrides(_ selector: Selector) -> Bool {
        var currentClass: AnyClass = type(of: self)
        let method: Method? = class_getInstanceMethod(currentClass, selector)

        while let superClass: AnyClass = class_getSuperclass(currentClass) {
            // Make sure we only check against non-nil returned instance methods.
            if class_getInstanceMethod(superClass, selector).map({ $0 != method}) ?? false { return true }
            currentClass = superClass
        }
        return false
    }
 }
