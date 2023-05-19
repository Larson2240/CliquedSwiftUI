//
//  SettingsViewModel.swift
//  Cliqued
//
//  Created by C211 on 23/01/23.
//

import UIKit

class SettingsViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isLogout: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variables
    private struct structUserStatus {
        var user_id = ""
        var is_online = ""
        var is_last_seen = ""
        var profileSetupType = ""
    }
    
    private var structUserStatusValue = structUserStatus()
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User){
        Constants.saveUserInfoAndProceed(user: user)
    }
    
    //MARK: - API Call
    func apiUpdateUserChatStatus() {
           let params: NSDictionary = [
                APIParams.userID: getUserId(),
                APIParams.is_online: getIsOnline(),
                APIParams.last_seen: getIsLastSeen(),
                APIParams.profile_setup_type : getProfileSetupType()
            ]
            
            print(params)
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async {
                    self.isLoaderShow.value = true
                }
                
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.UpdateProfile, parameters: params) { response, error, message in
                    DispatchQueue.main.async {
                        self.isLoaderShow.value = false
                    }
                    
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                        
                        if status == SUCCESS {
                            if let userArray = json?["user"] as? NSArray {
                                if userArray.count > 0 {
                                    let dicUser = userArray[0] as! NSDictionary
                                    let decoder = JSONDecoder()
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                        let objUser = try decoder.decode(User.self, from: jsonData)
                                        self.saveUserInfoAndProceed(user: objUser)
                                        self.isDataGet.value = true
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                    //self.isDataGet.value = true
                                }
                            }
                        } else {
                            self.isMessage.value = message ?? ""
                        }
                    }
                }
            } else {
                self.isMessage.value = Constants.alert_InternetConnectivity
            }
    }
    
    //MARK: Call Update Profile API
    func callLogoutAPI() {
        let params: NSDictionary = [
            APIParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async {
                self.isLoaderShow.value = true
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.Logout, parameters: params) { response, error, message in
                self.isLoaderShow.value = false
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        self.isLogout.value = true
                    } else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    func callDeleteAccountAPI() {
        let params: NSDictionary = [
            APIParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async {
                self.isLoaderShow.value = true
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.DeleteAccount, parameters: params) { response, error, message in
                self.isLoaderShow.value = false
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        self.isLogout.value = true
                    } else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    
}

extension SettingsViewModel {
    
    // getter methods
    func getUserId() -> String {
        return structUserStatusValue.user_id
    }
    
    func getIsOnline() -> String {
        return structUserStatusValue.is_online
    }
    
    func getIsLastSeen() -> String {
        return structUserStatusValue.is_last_seen
    }
    
    func getProfileSetupType() -> String {
        return structUserStatusValue.profileSetupType
    }
    
    // setter methods
    func setUserId(value:String) {
        structUserStatusValue.user_id = value
    }
    
    func setIsOnline(value:String) {
        structUserStatusValue.is_online = value
    }
    
    func setIsLastSeen(value:String) {
        structUserStatusValue.is_last_seen = value
    }
    
    func setProfileSetupType(value:String) {
        structUserStatusValue.profileSetupType = value
    }
}
