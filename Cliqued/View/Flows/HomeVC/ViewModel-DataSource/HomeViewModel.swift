//
//  HomeViewModel.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit

class HomeViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variable
    private var isDataLoad: Bool = false
    var arrayOfHomeCategory = [ActivityCategoryClass]()
    private var isRefresh: Bool = false
    private let apiParams = ApiParams()
    private let preferenceOptionIds = PreferenceOptionIds()
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User){
        Constants.saveUserInfoAndProceed(user: user)
    }
    
    //MARK: Call Get Preferences Data API
    func callGetUserInterestedCategoryAPI() {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)"
        ]
        
        if(Connectivity.isConnectedToInternet()) {
            DispatchQueue.main.async { [weak self] in
                self?.arrayOfHomeCategory.removeAll()
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUserInterestedCategory, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.isDataLoad = true
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let msg = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        if let activityArray = json?["user_interested_category"] as? NSArray {
                            if activityArray.count > 0 {
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
                                self.isDataGet.value = true
                            } else {
                                self.isDataGet.value = true
                            }
                        }
                    } else {
                        self.isMessage.value = msg ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    //MARK: Call Get Preferences Data API
    func callUpdateUserDeviceTokenAPI(is_enabled: Bool) {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.deviceType: "1",
            apiParams.deviceToken : UserDefaults.standard.object(forKey: kDeviceToken) ?? "123",
            apiParams.voipToken: UserDefaults.standard.object(forKey: USER_DEFAULT_KEYS.VOIP_TOKEN) ?? "123",
            apiParams.isPushEnabled : is_enabled ? "\(preferenceOptionIds.yes)" : "\(preferenceOptionIds.no)"
        ]
        
        if(Connectivity.isConnectedToInternet()) {
            
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.UpdateNotificationToken, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let msg = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        
                        if let userArray = json?["user"] as? NSArray {
                            if userArray.count > 0 {
                                let dicUser = userArray[0] as! NSDictionary
                                let decoder = JSONDecoder()
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                    let objUser = try decoder.decode(User.self, from: jsonData)
                                    self.saveUserInfoAndProceed(user: objUser)
//                                    self.isDataGet.value = true
                                } catch {
                                    print(error.localizedDescription)
                                }
                                //self.isDataGet.value = true
                            }
                        }
                        
                    } else {
                        self.isMessage.value = msg ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    //MARK: Call Get Preferences Data API
    func callGetPreferenceDataAPI() {
        
        if(Connectivity.isConnectedToInternet()) {
            RestApiManager.sharePreference.getResponseWithoutParams(webUrl: APIName.GetMasterPreferenceAPI) { [weak self] response, error, message in
                guard let self = self else { return }
                
                if(error != nil && response == nil) {
//                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    _ = json?[API_MESSAGE] as? String
                
                    if status == SUCCESS {
                        if let preferenceArray = json?["preference_types"] as? NSArray {
                            if preferenceArray.count > 0 {
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
                }
            }
        } else {
//            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    //MARK: Save preference data in UserDefault
    func savePreferenceData(preference: [PreferenceClass]){
        Constants.savePreferenceData(preferene: preference)
    }
}
//MARK: getter/setter method
extension HomeViewModel {
    
    func getNumberOfCategory() -> Int {
        arrayOfHomeCategory.count
    }
    
    func getCategoryData(at index: Int) -> ActivityCategoryClass {
        arrayOfHomeCategory[index]
    }
    
    func getIsDataLoad() -> Bool {
        return isDataLoad
    }
    func setIsDataLoad(value: Bool) {
        isDataLoad = value
    }
    
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrayOfHomeCategory.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    func getIsRefresh() -> Bool {
        return isRefresh
    }
    
    func setIsRefresh(value:Bool) {
        isRefresh = value
    }
}
