//
//  UserDefaultUtils.swift
//  Bubbles
//
//  Created by C100-107 on 10/04/20.
//  Copyright © 2020 C100-107. All rights reserved.
//
// MARK: Description - This is a constant file of UserDefaults.

import UIKit
import ContactsUI
import GoogleSignIn
import FBSDKLoginKit

//MARK: Gloabal Declare UserDefaults
let userDefaults = UserDefaults.standard

//MARK: UserDefault Key
struct structUserdefaultKey {
    let isLoggedIn              = "isLoggedIn"
    let userData                = "userData"
    
    let userEmail               = "email"
    let userPassword            = "Password"
    let userName                = "userName"
    let isRemeberMe             = "isRememberMe"
    
    let preferenceData          = "preferenceData"
}
var UserDefaultKey = structUserdefaultKey()

//MARK: Clear User Defautls
func clearUserDefault()
{
    let deviceToken = userDefaults.value(forKey: kDeviceToken)
    let voipToken = userDefaults.value(forKey: USER_DEFAULT_KEYS.VOIP_TOKEN)
    
    let domain = Bundle.main.bundleIdentifier!
    userDefaults.removePersistentDomain(forName: domain)
    userDefaults.synchronize()
    APP_DELEGATE.socketIOHandler?.disconnectSocket()
       
    //Facebook SignOut
    if let _ = AccessToken.current {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
    UIApplication.shared.applicationIconBadgeNumber = 0
    userDefaults.setValue(deviceToken, forKey: kDeviceToken)
    userDefaults.set(voipToken, forKey: USER_DEFAULT_KEYS.VOIP_TOKEN)
    CoreDataAdaptor.sharedDataAdaptor.deleteAllConversation()
    CoreDataAdaptor.sharedDataAdaptor.deleteAllMessage()
    
    //Google SignOut
    GIDSignIn.sharedInstance.signOut()
    checkSecurity()
}

func clearUserDefaultWithSocket()
{
    let deviceToken = userDefaults.value(forKey: kDeviceToken)
    let voipToken = userDefaults.value(forKey: USER_DEFAULT_KEYS.VOIP_TOKEN)
    
    let domain = Bundle.main.bundleIdentifier!
    userDefaults.removePersistentDomain(forName: domain)
    userDefaults.synchronize()
       
    //Facebook SignOut
    if let _ = AccessToken.current {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
    UIApplication.shared.applicationIconBadgeNumber = 0
    userDefaults.setValue(deviceToken, forKey: kDeviceToken)
    userDefaults.set(voipToken, forKey: USER_DEFAULT_KEYS.VOIP_TOKEN)
    CoreDataAdaptor.sharedDataAdaptor.deleteAllConversation()
    CoreDataAdaptor.sharedDataAdaptor.deleteAllMessage()
    
    //Google SignOut
    GIDSignIn.sharedInstance.signOut()
    checkSecurity()
}

extension UserDefaults{
    func setCustom<T: Codable>(_ value: T?, forKey: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: forKey)
    }
    
    func setCustomArr<T: Codable>(_ value: [T], forKey: String) {
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: forKey)
    }
    
    func getCustom<T>(_ type: T.Type, forKey: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: forKey) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    func getCustomArr<T>(_ type: T.Type, forKey: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: forKey) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
    
    func setCustomContactArr<CNContact: Codable>(_ value: [CNContact], forKey: String) {
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: forKey)
    }
    
    func getCustomContactArr<CNContact>(_ type: CNContact.Type, forKey: String) -> [CNContact] where CNContact : Decodable {
        guard let encodedData = array(forKey: forKey) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}

