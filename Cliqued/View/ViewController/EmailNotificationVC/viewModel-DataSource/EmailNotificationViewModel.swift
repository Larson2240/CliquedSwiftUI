//
//  EmailNotificationViewModel.swift
//  Cliqued
//
//  Created by C100-132 on 17/02/23.
//

import Foundation

class EmailNotificationViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())    
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variables
    private struct structEmailNotificationStatus {
        var user_id = ""
        var preference_id = ""
        var preference_option_id = ""
    }
    
    private var structEmailNotificationValue = structEmailNotificationStatus()
    var arrNotification = [PreferenceClass]()
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User){
        Constants.saveUserInfoAndProceed(user: user)
    }
    
    //MARK: - API Call
    func apiUpdateUserNotificationStatus() {
           let params: NSDictionary = [
                APIParams.userID: getUserId(),
                APIParams.preferenceId: getPreferenceId(),
                APIParams.preferenceOptionId: getPreferenceOptionId()
            ]
            
            print(params)
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async {
                    self.isLoaderShow.value = true
                }
                
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.UpdateNotificationSettings, parameters: params) { response, error, message in
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
}

extension EmailNotificationViewModel {
    
    // getter methods
    func getUserId() -> String {
        return structEmailNotificationValue.user_id
    }
    
    func getPreferenceId() -> String {
        return structEmailNotificationValue.preference_id
    }
    
    func getPreferenceOptionId() -> String {
        return structEmailNotificationValue.preference_option_id
    }
    
    // setter methods
    func setUserId(value:String) {
        structEmailNotificationValue.user_id = value
    }
    
    func setPreferenceId(value:String) {
        structEmailNotificationValue.preference_id = value
    }
 
    func setPreferenceOptionId(value:String) {
        structEmailNotificationValue.preference_option_id = value
    }
}
