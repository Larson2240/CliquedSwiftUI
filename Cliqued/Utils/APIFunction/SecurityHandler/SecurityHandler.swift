//
//  SecurityHandler.swift
//  Swing
//
//  Created by C110 on 21/11/17.
//  Copyright © 2017 C110. All rights reserved.
//

import Foundation

//MARK: UserDefault Key
let kAccessKey = "Accesskey"
let kSecretKey = "Secretkey"
let kDeviceType = "Devicetype"
let kDeviceToken = "Devicetoken"
let kIsTestData = "isTestData"
let kLanguage = "language"

let kNoUsername = "nousername"
let kTempToken = "tempToken"
let kGlobalPassword = "globalPassword"
let kUserGUID = "userGUID"
let kUserToken = "userToken"
let kAdminConfig = "adminConfig"
let isLogin = "is_login"
let WSDATA = "data"
let kAutorization = "Authorization"
let kAppToken = "appToken"

func includeSecurityCredentials() -> NSDictionary {
    let userDefaults = UserDefaults.standard
    
    let accessKey : String
    let secretKey : String
    
    var isTestData = "0"
#if DEBUG
    isTestData = "1"
#endif
    
    if (userDefaults.value(forKey: kGlobalPassword) != nil) && userDefaults.value(forKey: kUserGUID) != nil {
        
        accessKey = FBEncryptorAES.encryptBase64String(userDefaults.value(forKey: kUserGUID) as? String, keyString: userDefaults.value(forKey: kGlobalPassword) as? String, separateLines: false)
        print("AccessKey\(accessKey)")
        
    } else {
        accessKey = kNoUsername
    }
    
    if  (userDefaults.value(forKey: kUserToken) != nil) {
        secretKey = userDefaults.value(forKey: kUserToken) as! String
    }else if userDefaults.value(forKey: kTempToken) != nil {
        secretKey = userDefaults.value(forKey: kTempToken) as! String
    }else {
        secretKey =  ""
    }
    
    var strLanguage = LanguageStrCode.en.rawValue
    
    if let strCode = UserDefaults.standard.string(forKey: "language") {
        strLanguage = strCode
    } else if let strCode = UserDefaults.standard.string(forKey: "i18n_language") {
        strLanguage = strCode
    }
    
    return [kAccessKey:accessKey, kSecretKey:secretKey, kDeviceType:"1", kDeviceToken: userDefaults.object(forKey: kDeviceToken) ?? "12345", kIsTestData:isTestData, kLanguage: strLanguage] as NSDictionary
}

func checkSecurity() {
    let userDefaults = UserDefaults.standard
    
    if (userDefaults.value(forKey: kTempToken) == nil) {
        getTempToken()
    }
}

//MARK: - TempToken
func getTempToken() {
    let userDefaults = UserDefaults.standard
    
    RestApiManager.sharePreference.getResponseWithoutParams(webUrl: APIName.RefreshToken) { (response, error, messaage) in
        guard response != nil else { return }
        //let dicTemp:NSDictionary = (response as! NSDictionary).object(forKey: WSDATA) as! NSDictionary
        if (response as! NSDictionary).value(forKey: kTempToken) != nil && (response as! NSDictionary)["adminConfig"] != nil {
            let dicConfig = (response as! NSDictionary)["adminConfig"] as! NSArray;
            
            userDefaults.set((dicConfig[0] as AnyObject).value(forKey: "globalPassword"), forKey: kGlobalPassword)
            userDefaults.set((response as! NSDictionary).value(forKey: kTempToken), forKey: kTempToken)
        }
    }
}
