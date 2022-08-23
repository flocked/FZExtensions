//
//  Measure.swift
//  FZCollection
//
//  Created by Florian Zand on 23.05.22.
//

import Foundation

public class Measure {
    @discardableResult
    public class func printTimeElapsed(title:String, running operation:()->()) -> Double {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for \(title): \(timeElapsed) s.")
       return Double(timeElapsed)
    }

    public class func timeElapsed(running operation: ()->()) -> Double {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return Double(timeElapsed)
    }
}
