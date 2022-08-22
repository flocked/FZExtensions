//
//  Date.swift
//  FZExtensions
//
//  Created by Florian Zand on 07.06.22.
//

import Foundation

extension Date {
    func adding(_ value: Int, _ component: Calendar.Component) -> Date {
       return Calendar.current.date(byAdding: component, value: value, to: self)!
   }
    
     func subtracting(_ value: Int, _ component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: -value, to: self)!
    }
    
}
