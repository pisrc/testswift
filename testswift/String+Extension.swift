//
//  String+Extension.swift
//  testswift
//
//  Created by ryan on 7/23/16.
//  Copyright © 2016 musicpang. All rights reserved.
//

import Foundation

extension String
{
    var capitalizeFirst: String {
        if isEmpty { return "" }
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).uppercaseString)
        return result
    }
    
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func matches(regex: String) throws -> [String] {
        let re = try NSRegularExpression(pattern: regex, options: [])
        let matches = re.matchesInString(self, options: [], range: NSRange(location: 0, length: characters.count))
        
        let m = matches.map { (match) -> [String] in
            return [Int](1..<match.numberOfRanges).map { (i) -> String in
                return (self as NSString).substringWithRange(match.rangeAtIndex(i))
            }}
            .flatMap { $0 }
        return m
    }
    
    func containsRegex(regex: String) throws -> Bool {
        let re = try NSRegularExpression(pattern: regex, options: [])
        let matches = re.matchesInString(self, options: [], range: NSRange(location: 0, length: characters.count))
        
        if 0 < matches.count {
            return true
        }
        return false
    }
    
}