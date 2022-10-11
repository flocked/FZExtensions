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
    
    func toDictionary(from classType: NSObject.Type? = nil) -> [String: Any?] {
        let classType = classType ??  type(of: self)
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
 }
