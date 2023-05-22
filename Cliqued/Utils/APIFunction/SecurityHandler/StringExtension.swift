//
//  StringExtension.swift

//  LeeSeeApp
//
//  Created by C196 on 11/03/20.
//  Copyright © 2020 C196. All rights reserved.
//


import Foundation
import UIKit
public func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}
extension String
{
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    public var length: Int {
        return count
    }
    func isValid() -> Bool {
        return (isEmpty || self == "" || self == nil || self == "(null)") || blank() ? false : true
        
    }
    func blank() -> Bool {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    func isDecimal1Point() -> Bool
    {
        let regex : NSString = "\\d+(\\.\\d{1})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: self)
    }
    func isDecimal3Point() -> Bool
    {
        let regex : NSString = "\\d+(\\.\\d{3})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: self)
    }

    //MARK: Capitalizing first char of sentence
    func capitalizeFirst() -> String {
        let firstIndex = index(startIndex, offsetBy: 1)
        
        return substring(to: firstIndex).capitalized + substring(from: firstIndex).lowercased()
    }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

