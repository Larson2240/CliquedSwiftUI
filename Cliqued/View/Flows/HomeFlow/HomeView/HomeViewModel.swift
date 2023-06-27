//
//  HomeViewModel.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import SwiftUI
import UserNotifications

final class HomeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var profileCompleted = false
    @Published var favoriteActivity = [UserInterestedCategory]()
    @Published var favoriteCategoryActivity = [UserInterestedCategory]()
    @Published var arrayOfHomeCategory = [ActivityCategoryClass]()
    
    private let apiParams = ApiParams()
    private let preferenceOptionIds = PreferenceOptionIds()
    private let profileSetupType = ProfileSetupType()
    
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
    
    func checkProfileCompletion() {
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            profileCompleted = true
            checkPushNotificationEnabled()
        } else {
            profileCompleted = false
            bindUserDetailsData()
        }
    }
    
    func manageSetupProfileNavigationFlow() {
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
            APP_DELEGATE.window?.rootViewController =  UIHostingController(rootView: AgeView())
            
        case profileSetupType.gender:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NameView())
            
        case profileSetupType.relationship:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: RelationshipView(isFromEditProfile: false, arrayOfUserPreference: []))
            
        case profileSetupType.category:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: PickActivityView(isFromEditProfile: false, arrayOfActivity: favoriteActivity, activitiesFlowPresented: .constant(false)))
            
        case profileSetupType.sub_category:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: PickSubActivityView(isFromEditProfile: false, categoryIds: "", arrayOfSubActivity: [], activitiesFlowPresented: .constant(false)))
            
        case profileSetupType.profile_images:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: SelectPicturesView(arrayOfProfileImage: [], isFromEditProfile: false))
            
        case profileSetupType.location:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: LocationView(isFromEditProfile: false, addressId: ""))
            
        case profileSetupType.notification_enable:
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: NotificationsView())
            
        case profileSetupType.completed:
            let tabBarVC = TabBarVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: tabBarVC)
        default:
            break
        }
    }
    
    func imageURL(for activity: ActivityCategoryClass, imageSize: CGSize) -> URL? {
        let strUrl = UrlActivityImage + (activity.image ?? "")
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
        
        return URL(string: baseTimbThumb)
    }
    
    private func checkPushNotificationEnabled() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { [weak self] settings in
            guard let self = self else { return }
            
            if settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    self.callUpdateUserDeviceTokenAPI(is_enabled: false)
                    APP_DELEGATE.registerForPushNotifications()
                }
                // Notification permission has not been asked yet, go for it!
            } else if settings.authorizationStatus == .denied {
                
                DispatchQueue.main.async {
                    self.callUpdateUserDeviceTokenAPI(is_enabled: false)
                }
                
                // Notification permission was previously denied, go to settings & privacy to re-enable
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                APP_DELEGATE.registerForPushNotifications()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.callUpdateUserDeviceTokenAPI(is_enabled: true)
                }
            }
        })
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
            if let data = favoriteActivity.filter({ $0.activityId == activityId }).first {
                if !favoriteActivity.contains(where: {$0.activityId == activityId}) {
                    favoriteCategoryActivity.append(data)
                }
            }
        }
    }
}
