//
//  SignUpProcessViewModel.swift
//  Cliqued
//
//  Created by C211 on 30/01/23.
//

import UIKit

//MARK: Struct Relationship Param's
struct structRelationshipParam {
    var preference_id = ""
    var preference_option_id = ""
    var user_preference_id = ""
}
//MARK: Struct User Address Param's
struct structAddressParam {
    var address = ""
    var latitude = ""
    var longitude = ""
    var city = ""
    var state = ""
    var country = ""
    var pincode = ""
    var address_id = ""
}
//MARK: Struct Distance Param's
struct structDistanceParam {
    var distancePreferenceOptionId = ""
    var distancePreferenceId = ""
}
//MARK: Struct Distance Param's
struct structNotificationParam {
    var notificationPreferenceId = ""
    var notificationOptionId = ""
}

class SignUpProcessViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    private let apiParams = ApiParams()
    
    //MARK: Variables
    
    //MARK: Struct Main Param's
    private struct signupProcessParams {
        var name = ""
        var profileSetupType = ""
        var dateofbirth = ""
        var gender = ""
        var looking_for = ""
        var deletedLookingForIds = ""
        var pickActivities = ""
        var profileImages = [Any]()
        var deletedImageIds = ""
        var deletedCategoryIds = ""
        var deletedSubCategoryIds = ""
        var thumbnails = [UIImage]()
        var userAddress = [structAddressParam]()
        var distance: structDistanceParam?
        var notification: structNotificationParam?
    }
    private var structSignUpProcessValue = signupProcessParams()
    
    private var arrayRelationshipParam = [structRelationshipParam]()
    private var arrayUserAddressParam = [structAddressParam]()
    private var arrayDistanceParam = [structDistanceParam]()
    private var arrayNotificationParam = [structNotificationParam]()
    
    //MARK: Social Login API
    func callSignUpProcessAPI() {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.profile_setup_type : self.getProfileSetupType(),
            apiParams.name : self.getName(),
            apiParams.birthdate : self.getDateOfBirth(),
            apiParams.gender : self.getGender(),
            apiParams.looking_for : self.convertRelationshipStructToString(),
            apiParams.looking_for_deleted_id : self.getDeletedLookingForIds(),
            apiParams.activity_selection : self.getActivity(),
            apiParams.user_profile_image : self.getAllProfileImage(),
            apiParams.thumbnail : self.getAllThumbnails(),
            apiParams.userDeletedImageId : self.getDeletedProfileImagesIds(),
            apiParams.userDeletedCategoryId : self.getDeletedCategoryIds(),
            apiParams.userDeletedSubCategoryId : self.getDeletedSubCategoryIds(),
            apiParams.user_address : self.convertUserAddressStructToString(),
            apiParams.distance_pref : self.convertDistanceParamStructToString(),
            apiParams.notification_status : self.convertNotificationParamStructToString()
        ]
        
//        print("SignUpPrarams: \(params)")
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                self?.isLoaderShow.value = true
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.UpdateProfile, parameters: params) { [weak self] response, error, message in
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
                                    self.isDataGet.value = true
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    } else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        }
    }
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User){
        Constants.saveUserInfoAndProceed(user: user)
    }
}
//MARK: getter/setter method
extension SignUpProcessViewModel {
    
    //Get methods
    func getName() -> String {
        structSignUpProcessValue.name
    }
    func getProfileSetupType() -> String {
        structSignUpProcessValue.profileSetupType
    }
    func getDateOfBirth() -> String {
        structSignUpProcessValue.dateofbirth
    }
    func getGender() -> String {
        structSignUpProcessValue.gender
    }
    func getDeletedLookingForIds() -> String {
        structSignUpProcessValue.deletedLookingForIds
    }
    func getRelationship() -> [structRelationshipParam] {
        arrayRelationshipParam
    }
    func getActivity() -> String {
        structSignUpProcessValue.pickActivities
    }
    func getAllProfileImage() -> [Any] {
        structSignUpProcessValue.profileImages
    }
    func getAllThumbnails() -> [UIImage] {
        structSignUpProcessValue.thumbnails
    }
    func getDeletedProfileImagesIds() -> String {
        structSignUpProcessValue.deletedImageIds
    }
    func getDeletedCategoryIds() -> String {
        structSignUpProcessValue.deletedCategoryIds
    }
    func getDeletedSubCategoryIds() -> String {
        structSignUpProcessValue.deletedSubCategoryIds
    }
    func getUserAddress() -> [structAddressParam] {
        structSignUpProcessValue.userAddress
    }
    func getDistance() -> structDistanceParam {
        structSignUpProcessValue.distance ?? structDistanceParam()
    }
    func getNotification() -> structNotificationParam {
        structSignUpProcessValue.notification ?? structNotificationParam()
    }
    
    //Set methods
    func setName(value: String) {
        structSignUpProcessValue.name = value
    }
    func setProfileSetupType(value: String) {
        structSignUpProcessValue.profileSetupType = value
    }
    func setDateOfBirth(value: String) {
        structSignUpProcessValue.dateofbirth = value
    }
    func setGender(value: String) {
        structSignUpProcessValue.gender = value
    }
    func setRelationship(value: structRelationshipParam) {
        arrayRelationshipParam.append(value)
    }
    func setDeletedLookingForIds(value: String) {
        structSignUpProcessValue.deletedLookingForIds = value
    }
    func setActivity(value: String) {
        structSignUpProcessValue.pickActivities = value
    }
    func removeSelectedRelationship(Index: Int) {
        arrayRelationshipParam.remove(at: Index)
    }
    func setProfileImage(value: Any) {
        structSignUpProcessValue.profileImages.append(value)
    }
    func setThumbnails(value: UIImage) {
        structSignUpProcessValue.thumbnails.append(value)
    }
    func setDeletedProfileImagesIds(value: String) {
        structSignUpProcessValue.deletedImageIds = value
    }
    func setDeletedCateogryIds(value: String) {
        structSignUpProcessValue.deletedCategoryIds = value
    }
    func setDeletedSubCateogryIds(value: String) {
        structSignUpProcessValue.deletedSubCategoryIds = value
    }
    func setUserAddress(value: structAddressParam) {
        structSignUpProcessValue.userAddress.append(value)
    }
    func setDistance(value: structDistanceParam) {
        structSignUpProcessValue.distance = value
    }
    func setNotification(value: structNotificationParam) {
        structSignUpProcessValue.notification = value
    }
    
    //Other method's
    func clearProfileImageArray() {
        structSignUpProcessValue.profileImages.removeAll()
    }
    func clearThumnailImageArray() {
        structSignUpProcessValue.thumbnails.removeAll()
    }
    
    //MARK: Convert Relationship Struct to String
    func convertRelationshipStructToString() -> String {
        var optionlist = [String]()
        for i in getRelationship() {
            let dict : NSMutableDictionary = [apiParams.preferenceId : i.preference_id ,
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
        for i in getUserAddress() {
            let dict : NSMutableDictionary = [apiParams.address : i.address ,
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
        
        if !self.getDistance().distancePreferenceOptionId.isEmpty {
            let dict : NSMutableDictionary = [
                apiParams.distancePrefOptionId : self.getDistance().distancePreferenceOptionId,
                apiParams.distancePrefId : self.getDistance().distancePreferenceId
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
        
        if !self.getNotification().notificationOptionId.isEmpty {
            let dict : NSMutableDictionary = [
                apiParams.notificationPrefId : self.getNotification().notificationPreferenceId,
                apiParams.notificationOptionId : self.getNotification().notificationOptionId
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
