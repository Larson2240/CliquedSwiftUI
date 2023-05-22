//
//  optional.swift
//  MagicCube
//
//  Created by C110 on 15/12/17.
//  Copyright © 2017 C110. All rights reserved.
//

import Foundation
import Photos

extension Optional {
    func asStringOrEmpty() -> String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }
    func aIntOrEmpty() -> Int {
        switch self {
        case .some(let value):
            print(value)
            if "\(value)" == "<null>" {
                return 0
            }
            return value as! Int
        case _:
            return 0
        }
    }
    func aDoubleOrEmpty() -> Double {
        switch self {
        case .some(let value):
            print(value)
            return Double(String(describing: value))!
        case _:
            return 0.0
        }
    }
    
    func asStringOrNilText() -> String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return "(nil)"
        }
    }
}

extension Notification.Name {
    static let languageChange = Notification.Name("languageChange")
}


extension Locale {
    
    static var enLocale: Locale {
        
        return Locale(identifier: "en-EN")
    } // to use in **currentLanguage** to get the localizedString in English
    
    static var currentLanguage: Language1? {
        
        guard let code = preferredLanguages.first?.components(separatedBy: "-").first else {
            
            print("could not detect language code")
            
            return nil
        }
        
        guard let rawValue = enLocale.localizedString(forLanguageCode: code) else {
            
            print("could not localize language code")
            
            return nil
        }
        
        guard let language = Language1(rawValue: rawValue) else {
            
            print("could not init language from raw value")
            
            return nil
        }
        print("language: \(code)-\(rawValue)")
        
        return language
    }
    
    static var currentLanguageCode: LanguageStrCode? {
        
        guard let code = preferredLanguages.first?.components(separatedBy: "-").first else {
            
            print("could not detect language code")
            
            return nil
        }
        
        guard let rawValue = enLocale.localizedString(forLanguageCode: code) else {
            
            print("could not localize language code")
            
            return nil
        }
     
        print("language: \(code)-\(rawValue)")
        print("languageCode: \(String(describing: LanguageStrCode(rawValue: "\(code)") ?? LanguageStrCode(rawValue: "0")))")
        return LanguageStrCode(rawValue: "\(code)")
    }
}

extension Double {
    var clean: String {
       return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension PHAsset {
    var fileSize: Float {
        get {
            let resource = PHAssetResource.assetResources(for: self)
            if let imageSizeByte = resource.first?.value(forKey: "fileSize") as? NSNumber {
                let imgfloatValue = imageSizeByte.floatValue
                let imageSizeMB = imgfloatValue / (1024.0*1024.0)
                return imageSizeMB
            }
            return 0
        }
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: firstItem!, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
    }
    
    func setMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
            guard let firstItem = firstItem else {
                return self
            }
            NSLayoutConstraint.deactivate([self])
            let newConstraint = NSLayoutConstraint(item: firstItem, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
            newConstraint.priority = priority
            newConstraint.shouldBeArchived = shouldBeArchived
            newConstraint.identifier = identifier
            NSLayoutConstraint.activate([newConstraint])
            return newConstraint
        }
}
