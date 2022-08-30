//
//  File.swift
//  
//
//  Created by Florian Zand on 29.08.22.
//

import Foundation


public protocol DisplayableEnum : CaseIterable,Equatable
{
    static var count: Int { get }
    static func value(at index: Int) -> Self
    
    // Returns the index of a given value
    
    static func index(of value: Self) -> Int
    
    /// Returns the localized name at the given index
    
    static func localizedName(at index: Int) -> String
    var localizedName: String { get }
}


//----------------------------------------------------------------------------------------------------------------------

public extension DisplayableEnum
{
    static var count: Int
    {
        return self.allCases.count
    }

    static func value(at index: Int) -> Self
    {
        return Array(self.allCases)[index]
    }

    static func index(of value: Self) -> Int
    {
        return Array(self.allCases).firstIndex(of:value)!
    }

    static func localizedName(at index: Int) -> String
    {
        return self.value(at: index).localizedName
    }
    
    var localizedName:String
    {
        return "\(self)"
    }
}
