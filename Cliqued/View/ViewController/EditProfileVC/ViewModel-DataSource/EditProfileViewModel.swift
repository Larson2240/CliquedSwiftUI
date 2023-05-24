//
//  EditProfileViewModel.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit

//MARK: Struct Relationship Param's
struct structAgePreferenceParam {
    var age_start_id = ""
    var age_start_pref_id = ""
    var age_end_id = ""
    var age_end_pref_id = ""
}

class EditProfileViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variable
    private struct structUserDetails {
        var profileSetupType = ""
        var profileCollection = [UserProfileImages]()
        var name = ""
        var Age = ""
        var locationDistance = ""
        var aboutme = ""
        var favoriteActivity = [UserInterestedCategory]()
        var favoriteCategoryActivity = [UserInterestedCategory]()
        var loogkingForIds = ""
        var location = [UserAddress]()
        var height = ""
        var kids = ""
        var kidsPrefId = 0
        var kidsOptionId = 0
        var smoking = ""
        var smokingPrefId = 0
        var smokingOptionId = 0
        var distancePreference = ""
        var startAge = ""
        var endAge = ""
        var userPreferenceArray = [UserPreferences]()
        var distance: DistanceParam?
        var agePrefereneArray: structAgePreferenceParam?
    }
    private var structUserDetailsValue = structUserDetails()
    private var arrayAgePreferenceParam = [structAgePreferenceParam]()
    private let apiParams = ApiParams()
    
    //MARK: Bind data on screen from the user object.
    func bindUserDetailsData() {
        let userData = Constants.loggedInUser!
        self.setName(value: userData.name ?? "")
        self.setAboutMe(value: userData.aboutme ?? "")
        self.setLookingFor(value: userData.lookingForTitle ?? "")
        self.setHeight(value: userData.height ?? "")
        self.setSmoking(value: userData.smokingSelectionId ?? "")
        self.setKids(value: userData.kidsSelectionId ?? "")
        self.setDistancePreference(value: userData.distanceOptionId ?? "")
        
        self.setStartAge(value: userData.ageStartId ?? "")
        self.setEndAge(value: userData.ageEndId ?? "")
        
        if userData.userInterestedCategory?.count ?? 0 > 0 {
            if let favoriteActivity = userData.userInterestedCategory {
                self.setFavoriteActivity(value: favoriteActivity)
            }
        }
        if userData.userProfileImages?.count ?? 0 > 0 {
            if let profileImages = userData.userProfileImages {
                self.setUserProfileCollection(value: profileImages)
            }
        }
        if userData.userAddress?.count ?? 0 > 0 {
            if let userAddress = userData.userAddress {
                self.setLocation(value: userAddress)
            }
        }
        if userData.userPreferences?.count ?? 0 > 0 {
            if let userPreferences = userData.userPreferences {
                self.setUserPreferencesArray(value: userPreferences)
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
            if let data = self.getFavoriteActivity().filter({$0.activityId == activityId}).first {
                if !self.getFavoriteCategoryActivity().contains(where: {$0.activityId == activityId}) {
                    self.setFavoriteCategoryActivity(value: data)
                }
            }
        }
    }
    
    //MARK: Check Validation
    func checkValidation() -> Bool {
        var flag = false
        if structUserDetailsValue.name.trimmingCharacters(in: .whitespaces).isEmpty {
            self.isMessage.value = Constants.validMsg_validName
        } else if Int(structUserDetailsValue.height) ?? 0 > 0 && Int(structUserDetailsValue.height) ?? 0 < 100 {
            self.isMessage.value = Constants.alertMsg_validHeight
        } else if Int(structUserDetailsValue.height) ?? 0 > 220 {
            self.isMessage.value = Constants.alertMsg_validHeight
        } else {
            flag = true
        }
        return flag
    }
    
    //MARK: Social Login API
    func callSignUpProcessAPI() {
        
        if checkValidation() {
            let params: NSDictionary = [
                apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
                apiParams.profile_setup_type : self.getProfileSetupType(),
                apiParams.name : self.getName(),
                apiParams.about_me : self.getAboutMe(),
                apiParams.height : self.getHeight(),
                apiParams.kids_preference_id : self.getKidsPrefId(),
                apiParams.kids_option_id : self.getKidsOptionId(),
                apiParams.smoking_preference_id : self.getSmokingPrefId(),
                apiParams.smoking_option_id : self.getSmokingOptionId(),
                apiParams.distance_pref : self.convertDistanceParamStructToString(),
                apiParams.age_pref : self.convertAgePreferenceParamStructToString(),
            ]
            
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
    }
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User){
        Constants.saveUserInfoAndProceed(user: user)
    }
    
}
//MARK: getter/setter method
extension EditProfileViewModel {
    
    func getProfileSetupType() -> String {
        structUserDetailsValue.profileSetupType
    }
    func getName() -> String {
        structUserDetailsValue.name
    }
    func getAboutMe() -> String {
        structUserDetailsValue.aboutme
    }
    func getLookingFor() -> String {
        structUserDetailsValue.loogkingForIds
    }
    func getLocation() -> [UserAddress] {
        structUserDetailsValue.location
    }
    func getHeight() -> String {
        structUserDetailsValue.height
    }
    func getKids() -> String {
        structUserDetailsValue.kids
    }
    func getKidsPrefId() -> Int {
        structUserDetailsValue.kidsPrefId
    }
    func getKidsOptionId() -> Int {
        structUserDetailsValue.kidsOptionId
    }
    func getSmoking() -> String {
        structUserDetailsValue.smoking
    }
    func getSmokingPrefId() -> Int {
        structUserDetailsValue.smokingPrefId
    }
    func getSmokingOptionId() -> Int {
        structUserDetailsValue.smokingOptionId
    }
    func getDistancePreference() -> String {
        structUserDetailsValue.distancePreference
    }
    func getStartAge() -> String {
        structUserDetailsValue.startAge
    }
    func getEndAge() -> String {
        structUserDetailsValue.endAge
    }
    func getDistance() -> DistanceParam {
        structUserDetailsValue.distance ?? DistanceParam()
    }
    func getAgePreference() -> structAgePreferenceParam {
        structUserDetailsValue.agePrefereneArray ?? structAgePreferenceParam()
    }
    func getUserPreferencesArray() -> [UserPreferences] {
        structUserDetailsValue.userPreferenceArray
    }
    
    
    func getUserProfileCollection() -> [UserProfileImages] {
        structUserDetailsValue.profileCollection
    }
    
    func getNumberOfFavoriteActivity() -> Int {
        structUserDetailsValue.favoriteActivity.count
    }
    func getFavoriteActivity() -> [UserInterestedCategory] {
        structUserDetailsValue.favoriteActivity
    }
    func getFavoriteCategoryActivity() -> [UserInterestedCategory] {
        structUserDetailsValue.favoriteCategoryActivity
    }
    
    func setProfileSetupType(value: String) {
        structUserDetailsValue.profileSetupType = value
    }
    func setName(value: String) {
        structUserDetailsValue.name = value
    }
    func setAboutMe(value: String) {
        structUserDetailsValue.aboutme = value
    }
    func setLookingFor(value: String) {
        structUserDetailsValue.loogkingForIds = value
    }
    func setLocation(value: [UserAddress]) {
        structUserDetailsValue.location = value
    }
    func setHeight(value: String) {
        structUserDetailsValue.height = value
    }
    func setKids(value: String) {
        structUserDetailsValue.kids = value
    }
    func setKidsPrefId(value: Int) {
        structUserDetailsValue.kidsPrefId = value
    }
    func setKidsOptionId(value: Int) {
        structUserDetailsValue.kidsOptionId = value
    }
    func setSmoking(value: String) {
        structUserDetailsValue.smoking = value
    }
    func setSmokingPrefId(value: Int) {
        structUserDetailsValue.smokingPrefId = value
    }
    func setSmokingOptionId(value: Int) {
        structUserDetailsValue.smokingOptionId = value
    }
    func setDistancePreference(value: String) {
        structUserDetailsValue.distancePreference = value
    }
    func setStartAge(value: String) {
        structUserDetailsValue.startAge = value
    }
    func setEndAge(value: String) {
        structUserDetailsValue.endAge = value
    }
    func setDistance(value: DistanceParam) {
        structUserDetailsValue.distance = value
    }
    func setAgePreference(value: structAgePreferenceParam) {
        structUserDetailsValue.agePrefereneArray = value
    }
    
    func setUserProfileCollection(value: [UserProfileImages]) {
        structUserDetailsValue.profileCollection = value
    }
    
    func setFavoriteActivity(value: [UserInterestedCategory]) {
        structUserDetailsValue.favoriteActivity = value
    }
    func setFavoriteCategoryActivity(value: UserInterestedCategory) {
        structUserDetailsValue.favoriteCategoryActivity.append(value)
    }
    
    func setUserPreferencesArray(value: [UserPreferences]) {
        structUserDetailsValue.userPreferenceArray = value
    }
    
    func isCheckProfileImage() -> Bool {
        if structUserDetailsValue.profileCollection.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    
    //MARK: Convert User Address Struct to String
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
    
    //MARK: Convert User Address Struct to String
    func convertAgePreferenceParamStructToString() -> String {
        var optionlist = [String]()
        
        if !self.getAgePreference().age_start_id.isEmpty {
            let dict : NSMutableDictionary = [
                apiParams.ageStartId : self.getAgePreference().age_start_id ,
                apiParams.ageStartPrefId : self.getAgePreference().age_start_pref_id,
                apiParams.ageEndId : self.getAgePreference().age_end_id,
                apiParams.ageEndPrefId : self.getAgePreference().age_end_pref_id
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
