//
//  Date+Extension.swift
//  Bubbles
//
//  Created by C100-107 on 25/05/20.
//  Copyright © 2020 C100-107. All rights reserved.
//

import Foundation
let defaultDateFormat = "yyyy-MM-dd HH:mm:ss"

extension Date {
    func getSpecificDate(byAdding component: Calendar.Component, value: Int) -> Date {
        let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
        return Calendar.current.date(byAdding: component, value: value, to: noon)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    var startOfPreviousMonth: Date {
        var components = DateComponents()
        components.month = -1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    var endOfNextMonth: Date {
        var components = DateComponents()
        components.month = 2
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    
    
    func localToUTC(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dt = dateFormatter.date(from: toString(format: format))
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: dt!)
    }
    
    func UTCtoLocal(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: toString(format: format))
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: dt!)
    }
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toStringWithFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    var ticks: UInt64 {
        return UInt64((timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

extension DateFormatter {
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}


//Chat related
public extension Date {
    
    
    func UTCToLocal(format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: toString(format: format))
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: dt!)
    }
    
    func dateToStringWithFormat(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat=format
        return formatter.string(from: self)
    }
    
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    func onlyDateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat="dd MMM"
        return formatter.string(from: self)
    }
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
}
public func UTCStringToLocalString(date : String, time: String, outputFormat: String = "yyyy-MM-dd")->String{
 
    let str = "\(date) \(time)"
   
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: str)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let localdate =  dateFormatter.string(from: dt!)
    return localdate.toDate()?.toString(format: outputFormat) ?? "0000-00-00"
}
public func UTCTimeToLocalTime(date : String,time: String)->String{
 
    let str = "\(date) \(time)"
   
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: str)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let localdate =  dateFormatter.string(from: dt!)
    return localdate.toDate()?.toString(format: "h:mm a") ?? "0000-00-00"
}
public func stringToDate(_ str: String, format: String = "yyyy-MM-dd HH:mm:ss")->Date?{
    let formatter = DateFormatter()
    formatter.dateFormat=format
    return formatter.date(from: str)
}
public func timeAgo(for date: Date?) -> String? {
    
    let units:Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    var components: DateComponents? = nil
    if let aDate = date {
        components = Calendar.current.dateComponents(units, from: aDate, to: Date())//dateComponents(units, from: aDate, to: Date(), options: [])
    }
    if (components?.year ?? 0) > 0 {
        return date?.UTCToLocal(format: "yyyy-MM-dd")
    } else if (components?.month ?? 0) > 0 {
        return date?.UTCToLocal(format: "MM-dd HH:mm")
    } else if (components?.weekOfYear ?? 0) > 0 {
        return date?.UTCToLocal(format: "MM-dd HH:mm")
    } else if (components?.day ?? 0) > 0 {
        return date?.UTCToLocal(format: "MM-dd HH:mm")
    } else if (components?.hour ?? 0 >= 1) {
        return date?.UTCToLocal(format: "HH:mm")
    } else if (components?.minute ?? 0 >= 1) {
        return "\(Int(components?.minute ?? 0)) m ago"
    } else if (components?.second ?? 0 >= 10) {
        return "\(Int(components?.second ?? 0)) s ago"
    } else {
        return "Just now"
    }
}

public func timeAgoDate(for strDate: String?) -> String? {
    
    var dateStr  = strDate
    let formatter        = DateFormatter()
    
    if dateStr!.contains("+0000") {
        dateStr = dateStr!.replacingOccurrences(of: "+0000", with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    if dateStr == "0000-00-00 00:00:00" {
        return ""
    } else {
        let currDate = formatter.date(from: dateStr!)!
        
        let units:Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        var components: DateComponents? = nil
//        if let aDate = currDate {
            components = Calendar.current.dateComponents(units, from: currDate, to: Date())//dateComponents(units, from: aDate, to: Date(), options: [])
//        }
        if (components?.year ?? 0) > 0 {
            return currDate.UTCToLocal(format: "yyyy-MM-dd")
        } else if (components?.month ?? 0) > 0 {
            return currDate.UTCToLocal(format: "MM-dd HH:mm")
        } else if (components?.weekOfYear ?? 0) > 0 {
            return currDate.UTCToLocal(format: "MM-dd HH:mm")
        } else if (components?.day ?? 0) > 0 {
            return currDate.UTCToLocal(format: "MM-dd HH:mm")
        } else if (components?.hour ?? 0 >= 1) {
            return currDate.UTCToLocal(format: "HH:mm")
        } else if (components?.minute ?? 0 >= 1) {
            return "\(Int(components?.minute ?? 0)) m ago"
        } else if (components?.second ?? 0 >= 10) {
            return "\(Int(components?.second ?? 0)) s ago"
        } else {
            return "Just now"
        }
    }
   
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}
