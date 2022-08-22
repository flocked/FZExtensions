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
    
    public var year: Int {
        get {
            let components = Calendar.current.dateComponents([.year], from:self)
            if let year = components.year { return year }
            return 0 }
        set { self = Calendar.current.date(bySetting: .year, value: newValue, of: self)  }
    }

    
    public var month: Int {
        get {
            let components = Calendar.current.dateComponents([.month], from:self)
            if let month =  components.month { return month }
            return 0 }
        set { self = Calendar.current.date(bySetting: .month, value: newValue, of: self)  }
    }

    
    public var day: Int  {
        get {
            let components = Calendar.current.dateComponents([.day], from:self)
            if let day =  components.day { return day }
            return 0 }
        set { self = Calendar.current.date(bySetting: .day, value: newValue, of: self)  }
    }
    
    public var hour: Int  {
        get {
            let components = Calendar.current.dateComponents([.hour], from:self)
            if let day =  components.day { return day }
            return 0 }
        set { self = Calendar.current.date(bySetting: .hour, value: newValue, of: self)  }
    }
    
    public var minute: Int  {
        get {
            let components = Calendar.current.dateComponents([.minute], from:self)
            if let day =  components.day { return day }
            return 0 }
        set { self = Calendar.current.date(bySetting: .minute, value: newValue, of: self)  }
    }
    
    public var second: Int  {
        get {
            let components = Calendar.current.dateComponents([.second], from:self)
            if let day =  components.day { return day }
            return 0 }
        set { self = Calendar.current.date(bySetting: .second, value: newValue, of: self)  }
    }
    
    
}
