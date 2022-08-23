//
//  File.swift
//
//
//  Created by Florian Zand on 22.08.22.
//

import Foundation

 extension Calendar.Component: CaseIterable {
    public static var allCases: [Calendar.Component] {
        return [.month, .weekday, .weekdayOrdinal, .weekOfYear, .weekOfMonth, .year, .yearForWeekOfYear, .weekOfYear, .quarter, .nanosecond, .second, .hour, .month, .minute, .day, .era]
    }
}

public extension Calendar.Component {
    var stringRepresentations: [String]? {
        switch self {
        case .month: return ["months", "month", "mon"]
        case .weekOfMonth: return ["weeks", "week", "w"]
        case .minute: return  ["minutes", "minute", "mins", "min", "m"]
        case .day: return  ["days", "day", "d"]
        case .hour: return ["hours", "hour", "hrs", "hr", "h", "hs"]
        case .second: return ["seconds", "second", "secs", "sec", "s"]
        case .nanosecond: return ["nanoseconds", "nanosecond", "ns"]
        case .quarter: return ["quarters", "quarter"]
        default: return nil
        }
    }
    
    var timeInterval: Double? {
        switch self {
        case .era:      return nil
        case .year:     return (Calendar.Component.day.timeInterval! * 365.0)
        case .month:    return (Calendar.Component.minute.timeInterval! * 43800)
        case .day:      return 86400
        case .hour:     return 3600
        case .minute:   return 60
        case .second:   return 1
        case .quarter:  return (Calendar.Component.day.timeInterval! * 91.25)
        case .weekOfMonth, .weekOfYear: return (Calendar.Component.day.timeInterval! * 7)
        case .nanosecond:  return 1e-9
        default:        return nil
        }
    }
}
