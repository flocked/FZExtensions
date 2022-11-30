//
//  String+.swift
//  FZExtensions
//
//  Created by Florian Zand on 05.06.22.
//

import Foundation
import NaturalLanguage

public extension NSRange {
    func toClosedRange() -> ClosedRange<Int> {
        return self.lowerBound...self.upperBound
    }
}

public struct TextCheckingResult {
    private var dic = [String : String]()
    public var range: Range<String.Index>
    public init(source: String, textCheckingResult: NSTextCheckingResult, keys: [String]) {
        self.range = Range(textCheckingResult.range, in: source)!
        self.string = ""
        self.string = String(source[self.range])
        for key in keys {
            if let value = textCheckingResult.value(forKey: key) as? String {
                dic[key] = value
            }
        }
    }
    public var string: String
    public var keys: [String] {
        return dic.compactMap({$0.key})
    }
    
    public func string(forKey key: String) -> String? {
        return dic[key]
    }
}


public extension String {
    var lowercasedFirst: String {
        if isEmpty { return "" }
        return prefix(1).lowercased() + self.dropFirst()
    }
    
    var mangled: String {
        String(self.utf16.map { $0 - 1 }.compactMap(UnicodeScalar.init).map(Character.init))
    }

    var unmangled: String {
        String(self.utf16.map { $0 + 1 }.compactMap(UnicodeScalar.init).map(Character.init))
    }
    
    var capitalizedFirst: String {
        if isEmpty { return "" }
        return prefix(1).uppercased() + self.dropFirst()
    }
    
    func substrings(_ option: EnumerationOptions) -> [String] {
        var array = [String]()
        self.enumerateSubstrings(in: self.startIndex..., options: option) { _, range, _, _ in
            array.append(String(self[range]))
        }
        return array
    }
    
    var words: [String] {
        return self.substrings(.byWords)
    }
    
    var lines: [String] {
        return self.substrings(.byLines)
    }
    
    var sentences: [String] {
        return self.substrings(.bySentences)
    }
    
    func regexMatches(pattern: String, keys: [String] = []) -> [TextCheckingResult] {
    do {
        let text = self
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let nsString = text as NSString

        let results = regex.matches(in: text,
                                            options: [], range: NSMakeRange(0, nsString.length))
        
    
       return results.compactMap({TextCheckingResult(source: text, textCheckingResult: $0, keys: keys)})
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }}
    
    func substrings(between fromString: String, and toString: String) -> [String] {
        let pattern = fromString + "(.*?)" + toString
       return self.matches(regex: pattern)
    }
    
    func matches(regex pattern: String) -> [String] {
        let string = self
        var matches = [String]()
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        regex?.enumerateMatches(in: string, options: [], range: NSMakeRange(0, string.utf16.count)) { result, flags, stop in
            if let r = result?.range(at: 1), let range = Range(r, in: string) {
                matches.append(String(string[range]))
            }
        }
        return matches
    }
    
    func replacingOccurrences(of strings: [String], with replacement: String) -> String {
        var newString = self
        for string in strings {
            newString = newString.replacingOccurrences(of: string, with: replacement)
        }
        return newString
    }
    
   mutating func replacedOccurrences(of strings: [String], with replacement: String) {
       self = self.replacingOccurrences(of: strings, with: replacement)
    }
    
    mutating func replacedOccurrences(of string: String, with replacement: String) {
        self = self.replacingOccurrences(of: string, with: replacement)
     }
    
    func findPersonNames() -> [String] {
        var personNames = [String]()
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = self

        let tags = tagger.tags(
            in: self.startIndex..<self.endIndex,
            unit: .word,
            scheme: .nameType,
            options: [
                .omitPunctuation,
                .omitWhitespace,
                .omitOther,
                .joinNames
            ]
        )
        for (tag, range) in tags {
            switch tag {
            case .personalName?:
                personNames.append(String(self[range]))
            default:
                break
            }
        }

        return personNames
    }
}

public extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}
