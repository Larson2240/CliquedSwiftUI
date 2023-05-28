//
//  OnboardingViewModel.swift
//  Cliqued
//
//  Created by C211 on 30/01/23.
//

import Combine

struct RelationshipParam {
    var preference_id = ""
    var preference_option_id = ""
    var user_preference_id = ""
}

struct AddressParam {
    var address = ""
    var latitude = ""
    var longitude = ""
    var city = ""
    var state = ""
    var country = ""
    var pincode = ""
    var address_id = ""
}

struct DistanceParam {
    var distancePreferenceOptionId = ""
    var distancePreferenceId = ""
}

struct NotificationParam {
    var notificationPreferenceId = ""
    var notificationOptionId = ""
}

final class OnboardingViewModel: ObservableObject {
    static var shared = OnboardingViewModel()
    
    @Published var name = ""
    @Published var profileSetupType = ""
    @Published var dateOfBirth = ""
    @Published var gender = ""
    @Published var looking_for = ""
    @Published var deletedLookingForIds = ""
    @Published var pickActivities = ""
    @Published var profileImages = [Any]()
    @Published var deletedImageIds = ""
    @Published var deletedCategoryIds = ""
    @Published var deletedSubCategoryIds = ""
    @Published var thumbnails = [UIImage]()
    @Published var userAddress = [AddressParam]()
    @Published var distance = DistanceParam()
    @Published var notification = NotificationParam()
    
    private let apiParams = ApiParams()
    var nextAction: (() -> Void)?
    
    var arrayRelationshipParam = [RelationshipParam]()
    var arrayUserAddressParam = [AddressParam]()
    var arrayDistanceParam = [DistanceParam]()
    var arrayNotificationParam = [NotificationParam]()
    
    //MARK: Social Login API
    func callSignUpProcessAPI() {
        let params: NSDictionary = [
            apiParams.userID: "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.profile_setup_type: profileSetupType,
            apiParams.name: name,
            apiParams.birthdate: dateOfBirth,
            apiParams.gender: gender,
            apiParams.looking_for: convertRelationshipStructToString(),
            apiParams.looking_for_deleted_id: deletedLookingForIds,
            apiParams.activity_selection: pickActivities,
            apiParams.user_profile_image: profileImages,
            apiParams.thumbnail: thumbnails,
            apiParams.userDeletedImageId: deletedImageIds,
            apiParams.userDeletedCategoryId: deletedCategoryIds,
            apiParams.userDeletedSubCategoryId: deletedSubCategoryIds,
            apiParams.user_address: convertUserAddressStructToString(),
            apiParams.distance_pref: convertDistanceParamStructToString(),
            apiParams.notification_status: convertNotificationParamStructToString()
        ]
        
        guard Connectivity.isConnectedToInternet() else { return }
        
        UIApplication.shared.showLoader()
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.UpdateProfile, parameters: params) { [weak self] response, error, message in
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
                                self.nextAction?()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                } else {
                    UIApplication.shared.showAlertPopup(message: message ?? "")
                }
            }
        }
    }
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User) {
        Constants.saveUserInfoAndProceed(user: user)
    }
}

extension OnboardingViewModel {
    //MARK: Convert Relationship Struct to String
    func convertRelationshipStructToString() -> String {
        var optionlist = [String]()
        for i in arrayRelationshipParam {
            let dict : NSMutableDictionary = [apiParams.preferenceId : i.preference_id,
                                              apiParams.preferenceOptionId : i.preference_option_id,
                                              apiParams.userPreferenceId : i.user_preference_id
            ]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            optionlist.append(jsonstringstr!)
        }
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        
        return jsonstring!
    }
    
    //MARK: Convert User Address Struct to String
    func convertUserAddressStructToString() -> String {
        var optionlist = [String]()
        for i in userAddress {
            let dict : NSMutableDictionary = [apiParams.address : i.address,
                                              apiParams.latitude : i.latitude,
                                              apiParams.longitude : i.longitude,
                                              apiParams.city : i.city,
                                              apiParams.state : i.state,
                                              apiParams.country : i.country,
                                              apiParams.pincode : i.pincode,
                                              apiParams.addressId : i.address_id
            ]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            optionlist.append(jsonstringstr!)
        }
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        return jsonstring!
    }
    
    //MARK: Convert Distance Struct to String
    func convertDistanceParamStructToString() -> String {
        var optionlist = [String]()
        
        if !distance.distancePreferenceOptionId.isEmpty {
            let dict : NSMutableDictionary = [
                apiParams.distancePrefOptionId : distance.distancePreferenceOptionId,
                apiParams.distancePrefId : distance.distancePreferenceId
            ]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            optionlist.append(jsonstringstr!)
        }
        
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        
        return jsonstring!
    }
    
    //MARK: Convert Notification Struct to String
    func convertNotificationParamStructToString() -> String {
        var optionlist = [String]()
        
        if !notification.notificationOptionId.isEmpty {
            let dict : NSMutableDictionary = [
                apiParams.notificationPrefId : notification.notificationPreferenceId,
                apiParams.notificationOptionId : notification.notificationOptionId
            ]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            optionlist.append(jsonstringstr!)
        }
        
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        
        return jsonstring!
    }
}
