//
//  String+Extension.swift
//  Bubbles
//
//  Created by C100-107 on 25/05/20.
//  Copyright © 2020 C100-107. All rights reserved.
//

import Foundation
import UIKit
let defaultDate = "0000-00-00 00:00:00"
let defaultDateOnly = "0000-00-00"
let defaultTimeOnly = "00:00:00"
let defaultDateFormatOnly = "yyyy-MM-dd"
let defaultTimeFormatOnly = "HH:mm:ss"

extension String {
    
    func localized() ->String {

        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
            // we set a default, just in case
            UserDefaults.standard.set("en", forKey: "i18n_language")
            UserDefaults.standard.synchronize()
        }

        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
     
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func isPasswordValid() -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}$")
        return passwordTest.evaluate(with: self)
    }
    
    static let shortDateUS: DateFormatter = {
        let formatter = DateFormatter(format: "MM-dd-yyyy")
        formatter.dateStyle = .short
        return formatter
    }()
    
    var shortDateUS: Date? {
        return String.shortDateUS.date(from: self)
    }
    
    func getFnameAndLName() -> [String] {
        
        let name = self
        var arrOfName: [String] = [name]
        
        if (name.contains(" ")) {
            let arr = name.split(separator: " ")
            for str in arr {
                arrOfName.append(String(str))
            }
        }
        
        if arrOfName.count > 1 {
            arrOfName.remove(at: 0)
        }
        
        let fname = String(arrOfName[0]).trimmingCharacters(in: .whitespaces)
        var lname = ""
        
        arrOfName.remove(at: 0)
        for str in arrOfName {
            lname += str + " "
        }
        
        lname = String(lname.dropLast())
        lname = lname.trimmingCharacters(in: .whitespaces)
        
        return [fname, lname]
    }
    
    func toDate (format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String = "yyyy-MM-dd HH:mm:ss", outputFormat: String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
    
    func fromBase64() -> String? {
            guard let data = Data(base64Encoded: self) else {
                return nil
            }

            return String(data: data, encoding: .utf8)
        }

        func toBase64() -> String {
            return Data(self.utf8).base64EncodedString()
        }
    
    /*  func timeAgo() -> String? {
     
     let date = self.toDate()
     
     let units:Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
     var components: DateComponents? = nil
     if let aDate = date {
     components = Calendar.current.dateComponents(units, from: aDate, to: Date())
     }
     
     var strTimeAgo: String?
     
     if (components?.year ?? 0) > 0 || (components?.month ?? 0) > 0 || (components?.weekOfYear ?? 0) > 0 {
     strTimeAgo = date?.toString(format: "dd/MM/yyyy")
     } else if (components?.day ?? 0) == 1 {
     strTimeAgo = "Yesterday"
     }  else if (components?.day ?? 0) > 0 {
     strTimeAgo = date?.toString(format: "dd/MM/yyyy")
     } else if (components?.hour ?? 0 >= 1) {
     strTimeAgo = date?.toString(format: "h:mm a")
     } else if (components?.minute ?? 0 >= 1) {
     strTimeAgo = "\(Int(components?.minute ?? 0))m ago"
     } else if (components?.second ?? 0 >= 10) {
     strTimeAgo = "\(Int(components?.second ?? 0))s ago"
     } else {
     strTimeAgo = "Just now"
     }
     
     return strTimeAgo
     }*/
    func messageTimeAgo() -> String? {
        
        let date = self.toDate()?.UTCtoLocal().toDate()
        
        let units:Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        var components: DateComponents? = nil
        if let aDate = date {
            components = Calendar.current.dateComponents(units, from: aDate, to: Date())
        }
        
        var strTimeAgo: String?
        
        
        if (components?.day ?? 0) > 0 {
            strTimeAgo = date?.toString(format: "h:mm a")
        }else if (components?.hour ?? 0 >= 1) {
            strTimeAgo = date?.toString(format: "h:mm a")
        } else if (components?.minute ?? 0 >= 1) {
            strTimeAgo = "\(Int(components?.minute ?? 0))m ago"
        } else if (components?.second ?? 0 >= 10) {
            strTimeAgo = "\(Int(components?.second ?? 0))s ago"
        } else {
            strTimeAgo = "Just now"
        }
        
        
        return strTimeAgo
    }
    func timeAgo(toDate: Date = Date()) -> String {
       
        let units:Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        guard let date = self.toDate()?.UTCtoLocal().toDate() else {
            return self
        }
        
        let components = Calendar.current.dateComponents(units, from: date, to: toDate)
        var strTimeAgo: String = ""
        
        if (components.year ?? 0) > 0 || (components.month ?? 0) > 0 || (components.day ?? 0) > 1 {
            strTimeAgo = date.toString(format: "dd/MM/yyyy")
            
        } else if (components.day ?? 0) == 1 {
            strTimeAgo = "Yesterday"
            
        } else if let hour = components.hour, hour > 0 {
            strTimeAgo = hour.description + " hours ago"
            
        } else if let minute = components.minute, minute > 0 {
            strTimeAgo = "\(minute) minutes ago"
            
        } else if let second = components.second, second > 0 {
            strTimeAgo = "\(second) seconds ago"
            
        } else if let second = components.second, second == 0 {
            strTimeAgo = "Just now"
            
        } else {
            strTimeAgo = self
        }
        
        return strTimeAgo
    }
    
    func messageDateAgo() -> String? {
        guard let date = self.toDate(format: "yyyy-MM-dd") else {
            return self
        }
        
        let units: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let components = Calendar.current.dateComponents(units, from: date, to: Date())
        
        var strTimeAgo = ""
        
        if (components.year ?? 0) > 0 || (components.month ?? 0) > 0 || (components.day ?? 0) > 1 {
            strTimeAgo = date.toString(format: "MM-dd-yyyy")
            
        } else if (components.day ?? 0) == 1 {
            strTimeAgo = "Yesterday"    
            
        } else {
            strTimeAgo = "Today"
        }
        
        return strTimeAgo
    }
    func toLocalDate(format: String = defaultDateFormat) -> Date? {
        let date = DateFormatter(format: format).date(from: self)?.UTCtoLocal().toDate()
        return date
    }
}
/*
 Will generate radom string based on length
 */
//public func randomString(length: Int) -> String {
//    
//    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//    let len = UInt32(letters.length)
//    var randomString = ""
//    for _ in 0 ..< length {
//        let rand = arc4random_uniform(len)
//        var nextChar = letters.character(at: Int(rand))
//        randomString += NSString(characters: &nextChar, length: 1) as String
//    }
//    return randomString
//}

public func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

public func convertToArray(text: String) -> [[String: Any]]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
