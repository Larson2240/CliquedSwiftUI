//
//  WelcomeViewModel.swift
//  Cliqued
//
//  Created by C211 on 27/01/23.
//

import UIKit
import SwiftUI

class WelcomeViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variable
    var emailNotVerifiedCount = 0
    var arrayOfPreferences = [PreferenceClass]()
    var arrayOfReportList = [ReportClass]()
    
    private let apiParams = ApiParams()
    
    //MARK: Call Get Preferences Data API
    func callGetPreferenceDataAPI() {
        
        if(Connectivity.isConnectedToInternet()) {
            RestApiManager.sharePreference.getResponseWithoutParams(webUrl: APIName.GetMasterPreferenceAPI) { [weak self] response, error, message in
                guard let self = self else { return }
                
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    _ = json?[API_MESSAGE] as? String
                
                    if status == SUCCESS {
                        if let preferenceArray = json?["preference_types"] as? NSArray {
                            if preferenceArray.count > 0 {
                                for preferenceInfo in preferenceArray {
                                    let dicPreference = preferenceInfo as! NSDictionary
                                    let decoder = JSONDecoder()
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject:dicPreference)
                                        let preferenceData = try decoder.decode(PreferenceClass.self, from: jsonData)
                                        self.arrayOfPreferences.append(preferenceData)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                                self.savePreferenceData(preference: self.arrayOfPreferences)
                            }
                        }
                        if let reportArray = json?["report_reason"] as? NSArray {
                            if reportArray.count > 0 {
                                for reportInfo in reportArray {
                                    let dicReport = reportInfo as! NSDictionary
                                    let decoder = JSONDecoder()
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject:dicReport)
                                        let reportData = try decoder.decode(ReportClass.self, from: jsonData)
                                        self.arrayOfReportList.append(reportData)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    //MARK: Call Update Profile API
    func callGetUserDetailsAPI() {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)"
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                self?.isLoaderShow.value = true
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUserDetails, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.isLoaderShow.value = false
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
                                    if Constants.loggedInUser?.isVerified == "1" {
                                        self.isDataGet.value = true
                                    } else {
                                        self.setEmailNotVerifiedCount()
                                        if self.getEmailNotVerifiedCount() > 2 {
                                            checkSecurity()
                                            let registerOptionsView = UIHostingController(rootView: RegisterOptionsView())
                                            APP_DELEGATE.window?.rootViewController = registerOptionsView
                                        } else {
                                            self.isMessage.value = Constants.validMsg_emailNotVerified
                                        }
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                                
                            } else {
                                self.isDataGet.value = true
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
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User){
        Constants.saveUserInfoAndProceed(user: user)
    }
    //MARK: Save preference data in UserDefault
    func savePreferenceData(preference: [PreferenceClass]){
        Constants.savePreferenceData(preferene: preference)
    }
}
//MARK: getter/setter method
extension WelcomeViewModel {
    
    //Get methods
    func getEmailNotVerifiedCount() -> Int {
        return emailNotVerifiedCount
    }
    
    func setEmailNotVerifiedCount() {
        emailNotVerifiedCount = emailNotVerifiedCount + 1
    }
}
