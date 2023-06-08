//
//  HomeViewModel.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import Combine

final class HomeViewModel: ObservableObject {
    private let apiParams = ApiParams()
    private let preferenceOptionIds = PreferenceOptionIds()
    
    @Published var isLoading = false
    @Published var arrayOfHomeCategory = [ActivityCategoryClass]()
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User){
        Constants.saveUserInfoAndProceed(user: user)
    }
    
    //MARK: Call Get Preferences Data API
    func callGetUserInterestedCategoryAPI() {
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)"
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        arrayOfHomeCategory.removeAll()
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUserInterestedCategory, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            if error != nil && response == nil {
                UIApplication.shared.showAlertPopup(message: message ?? "")
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                let msg = json?[API_MESSAGE] as? String
                
                guard
                    status == SUCCESS,
                    let activityArray = json?["user_interested_category"] as? NSArray,
                    activityArray.count > 0
                else {
                    UIApplication.shared.showAlertPopup(message: msg ?? "")
                    return
                }
                
                for activityInfo in activityArray {
                    let dicActivity = activityInfo as! NSDictionary
                    let decoder = JSONDecoder()
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:dicActivity)
                        let activityData = try decoder.decode(ActivityCategoryClass.self, from: jsonData)
                        
                        self.arrayOfHomeCategory.append(activityData)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
        
    func callUpdateUserDeviceTokenAPI(is_enabled: Bool) {
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.deviceType: "1",
            apiParams.deviceToken : UserDefaults.standard.object(forKey: kDeviceToken) ?? "123",
            apiParams.voipToken: UserDefaults.standard.object(forKey: USER_DEFAULT_KEYS.VOIP_TOKEN) ?? "123",
            apiParams.isPushEnabled : is_enabled ? "\(preferenceOptionIds.yes)" : "\(preferenceOptionIds.no)"
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.UpdateNotificationToken, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            if error != nil && response == nil {
                UIApplication.shared.showAlertPopup(message: message ?? "")
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                let msg = json?[API_MESSAGE] as? String
                
                guard
                    status == SUCCESS,
                    let userArray = json?["user"] as? NSArray,
                    userArray.count > 0
                else {
                    UIApplication.shared.showAlertPopup(message: msg ?? "")
                    return
                }
                
                let dicUser = userArray[0] as! NSDictionary
                let decoder = JSONDecoder()
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                    let objUser = try decoder.decode(User.self, from: jsonData)
                    self.saveUserInfoAndProceed(user: objUser)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: Call Get Preferences Data API
    func callGetPreferenceDataAPI() {
        guard Connectivity.isConnectedToInternet() else { return }
        
        RestApiManager.sharePreference.getResponseWithoutParams(webUrl: APIName.GetMasterPreferenceAPI) { [weak self] response, error, message in
            guard let self = self else { return }
            
            if error != nil && response == nil {
                
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                _ = json?[API_MESSAGE] as? String
                
                guard
                    status == SUCCESS,
                    let preferenceArray = json?["preference_types"] as? NSArray,
                    preferenceArray.count > 0
                else { return }
                
                var arrayOfPreferences = [PreferenceClass]()
                
                for preferenceInfo in preferenceArray {
                    let dicPreference = preferenceInfo as! NSDictionary
                    let decoder = JSONDecoder()
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject:dicPreference)
                        let preferenceData = try decoder.decode(PreferenceClass.self, from: jsonData)
                        arrayOfPreferences.append(preferenceData)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                self.savePreferenceData(preference: arrayOfPreferences)
            }
        }
    }
    
    //MARK: Save preference data in UserDefault
    func savePreferenceData(preference: [PreferenceClass]){
        Constants.savePreferenceData(preferene: preference)
    }
}
