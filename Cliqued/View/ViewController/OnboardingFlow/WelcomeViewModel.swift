//
//  WelcomeViewModel.swift
//  Cliqued
//
//  Created by C211 on 27/01/23.
//

import SwiftUI

class WelcomeViewModel: ObservableObject {
    private let profileSetupType = ProfileSetupType()
    private var favoriteActivity = [UserInterestedCategory]()
    private var arrayOfPreferences = [PreferenceClass]()
    private var arrayOfReportList = [ReportClass]()
    private var favoriteCategoryActivity = [UserInterestedCategory]()
    
    private let apiParams = ApiParams()
    
    func viewAppeared() {
        bindUserDetailsData()
        callGetPreferenceDataAPI()
    }
    
    private func bindUserDetailsData() {
        let userData = Constants.loggedInUser!
        
        if userData.userInterestedCategory?.count ?? 0 > 0 {
            if let interestedActivity = userData.userInterestedCategory {
                favoriteActivity = interestedActivity
            }
        }

        //MARK: Managed multiple same category object in one category object
        var arrayOfActivityIds = [Int]()
        if userData.userInterestedCategory?.count ?? 0 > 0 {
            for interestedCategoryData in userData.userInterestedCategory ?? [] {
                if let activityId = interestedCategoryData.activityId {
                    arrayOfActivityIds.append(activityId)
                }
            }
        }
        
        for activityId in arrayOfActivityIds {
            if let data = favoriteActivity.filter({ $0.activityId == activityId}).first {
                if !favoriteActivity.contains(where: { $0.activityId == activityId }) {
                    favoriteCategoryActivity.append(data)
                }
            }
        }
    }
    
    private func callGetPreferenceDataAPI() {
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        RestApiManager.sharePreference.getResponseWithoutParams(webUrl: APIName.GetMasterPreferenceAPI) { [weak self] response, error, message in
            guard let self = self else { return }
            
            if error != nil && response == nil {
                UIApplication.shared.showAlertPopup(message: message ?? "")
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
    }
    
    //MARK: Call Update Profile API
    func callGetUserDetailsAPI() {
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)"
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUserDetails, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            UIApplication.shared.hideLoader()
            if error != nil && response == nil {
                UIApplication.shared.showAlertPopup(message: message ?? "")
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
                                    self.manageSetupProfileNavigationFlow()
                                } else {
                                    UIApplication.shared.showAlertPopup(message: Constants.validMsg_emailNotVerified)
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                        } else {
                            self.manageSetupProfileNavigationFlow()
                        }
                    }
                } else {
                    UIApplication.shared.showAlertPopup(message: message ?? "")
                }
            }
        }
    }
    
    //MARK: Save user data in UserDefault
    private func saveUserInfoAndProceed(user: User) {
        Constants.saveUserInfoAndProceed(user: user)
    }
    //MARK: Save preference data in UserDefault
    private func savePreferenceData(preference: [PreferenceClass]){
        Constants.savePreferenceData(preferene: preference)
    }
    
    private func manageSetupProfileNavigationFlow() {
        let strCount: String?
        
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            let profile_setup_count = Int((Constants.loggedInUser?.profileSetupType)!)!
            strCount = "\(profile_setup_count)"
        } else {
            let profile_setup_count = Int((Constants.loggedInUser?.profileSetupType)!)! + 1
            strCount = "\(profile_setup_count)"
        }
        
        switch strCount {
        case profileSetupType.name:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NameView())
            
        case profileSetupType.birthdate:
            let agevc = AgeVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController =  UINavigationController(rootViewController: agevc)
            
        case profileSetupType.gender:
            let gendervc = GenderVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: gendervc)
            
        case profileSetupType.relationship:
            let relationshipvc = RelationshipVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: relationshipvc)
            
        case profileSetupType.category:
            let pickactivityvc = PickActivityVC.loadFromNib()
            pickactivityvc.arrayOfActivity = favoriteActivity
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: pickactivityvc)
            
        case profileSetupType.sub_category:
            let picksubactivityvc = PickSubActvityVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: picksubactivityvc)
            
        case profileSetupType.profile_images:
            let selectpicturevc = SelectPicturesVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: selectpicturevc)
            
        case profileSetupType.location:
            let locationvc = SetLocationVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: locationvc)
            
        case profileSetupType.notification_enable:
            let notificationvc = NotificationPermissionVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: notificationvc)
            
        case profileSetupType.completed:
            let startexplorevc = StartExploringVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: startexplorevc)
        default:
            break
        }
    }
}
