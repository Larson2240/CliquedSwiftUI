//
//  ProfileViewModel.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit

class ProfileViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isLikdDislikeSuccess: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variable
    private struct structUserDetails {
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
        var smoking = ""
        var distancePreference = ""
        var startAge = ""
        var endAge = ""
    }
    private var structUserDetailsValue = structUserDetails()
    var objUserDetails: User?
    
    //MARK: Call Update Profile API
    //    func callGetUserDetailsAPI() {
    //
    //        let params: NSDictionary = [
    //            APIParams.userID : "\(Constants.loggedInUser?.id ?? 0)"
    //        ]
    //
    //        if(Connectivity.isConnectedToInternet()){
    //            DispatchQueue.main.async {
    //                self.isLoaderShow.value = true
    //            }
    //            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUserDetails, parameters: params) { response, error, message in
    //                self.isLoaderShow.value = false
    //                if(error != nil && response == nil) {
    //                    self.isMessage.value = message ?? ""
    //                } else {
    //                    let json = response as? NSDictionary
    //                    let status = json?[API_STATUS] as? Int
    //                    let message = json?[API_MESSAGE] as? String
    //
    //                    if status == SUCCESS {
    //
    //                        if let userArray = json?["user"] as? NSArray {
    //                            if userArray.count > 0 {
    //                                let dicUser = userArray[0] as! NSDictionary
    //                                let decoder = JSONDecoder()
    //                                do {
    //                                    let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
    //                                    let objUser = try decoder.decode(User.self, from: jsonData)
    //                                    self.objUserDetails = objUser
    //                                    self.bindActivityUserDetailsData()
    //                                } catch {
    //                                    print(error.localizedDescription)
    //                                }
    //                                self.isDataGet.value = true
    //                            } else {
    //                                self.isDataGet.value = true
    //                            }
    //                        }
    //                    } else {
    //                        self.isMessage.value = message ?? ""
    //                    }
    //                }
    //            }
    //        } else {
    //            self.isMessage.value = Constants.alert_InternetConnectivity
    //        }
    //    }
    
    //MARK: Bind data on screen from the user object.
    func bindActivityUserDetailsData() {
        let userData = Constants.loggedInUser!
        self.setName(value: userData.name ?? "")
        self.setAge(value: "\(userData.age ?? 0)")
        let distanceInKm = String(format: "%.2f", userData.distanceInkm ?? 0.0)
        self.setLocationDistance(value: "\(distanceInKm)")
        self.setAboutMe(value: userData.aboutme ?? "")
        self.setHeight(value: userData.height ?? "")
        
        /*
         if userData.userPreferences?.count ?? 0 > 0 {
         var arrayOfPreference = [UserPreferences]()
         arrayOfPreference = userData.userPreferences ?? []
         
         var strTypes = ""
         
         let arrFriendship = arrayOfPreference.filter({$0.subTypesOfPreference == PreferenceTypeIds.friendship})
         
         for obj in arrFriendship {
         if strTypes.isEmpty {
         strTypes = obj.preferenceOptionTitle!
         } else {
         strTypes = "\(strTypes),\(obj.preferenceOptionTitle ?? "")"
         }
         }
         
         let arrRomance = arrayOfPreference.filter({$0.subTypesOfPreference == PreferenceTypeIds.romance})
         
         if arrFriendship.count > 0 && arrRomance.count > 0  {
         strTypes = "\(strTypes) - "
         }
         
         for obj in arrRomance {
         if strTypes.isEmpty {
         strTypes = obj.preferenceOptionTitle!
         } else {
         strTypes = "\(strTypes),\(obj.preferenceOptionTitle ?? "")"
         }
         }
         
         self.setLookingFor(value: "\(userData.lookingForTitle ?? "") (\(strTypes))")
         }
         */
        
        self.setLookingFor(value: userData.lookingForTitle ?? "")
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
        
        //MARK: Managed multiple same category object in one category object
        var arrayOfActivityIds = [Int]()
        if userData.userInterestedCategory?.count ?? 0 > 0 {
            for interestedCategoryData in userData.userInterestedCategory ?? [] {
                if let activityId = interestedCategoryData.activityId {
                    arrayOfActivityIds.append(activityId)
                }
            }
        }
        
        
        removeFavoriteActivityCategoryArray()
        for activityId in arrayOfActivityIds {
            if self.getFavoriteCategoryActivity().contains(where: {$0.activityId == activityId}) == false {
                if let data = self.getFavoriteActivity().filter({$0.activityId == activityId}).first {
                    self.setFavoriteCategoryActivity(value: data)
                }
            }
        }
    }
}
//MARK: getter/setter method
extension ProfileViewModel {
    
    func getName() -> String {
        structUserDetailsValue.name
    }
    func getAge() -> String {
        structUserDetailsValue.Age
    }
    func getStartAge() -> String {
        structUserDetailsValue.startAge
    }
    func getEndAge() -> String {
        structUserDetailsValue.endAge
    }
    func getLocationDistance() -> String {
        structUserDetailsValue.locationDistance
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
    func getSmoking() -> String {
        structUserDetailsValue.smoking
    }
    func getDistancePreference() -> String {
        structUserDetailsValue.distancePreference
    }
    
    func isCheckProfileImage() -> Bool {
        if structUserDetailsValue.profileCollection.count == 0 {
            return true
        } else {
            return false
        }
    }
    func getNumberOfUserProfile() -> Int {
        structUserDetailsValue.profileCollection.count
    }
    func getUserProfileData(at Index: Int) -> UserProfileImages {
        structUserDetailsValue.profileCollection[Index]
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
    
    
    func setName(value: String) {
        structUserDetailsValue.name = value
    }
    func setAge(value: String) {
        structUserDetailsValue.Age = value
    }
    func setStartAge(value: String) {
        structUserDetailsValue.startAge = value
    }
    func setEndAge(value: String) {
        structUserDetailsValue.endAge = value
    }
    func setLocationDistance(value: String) {
        structUserDetailsValue.locationDistance = value
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
    func setSmoking(value: String) {
        structUserDetailsValue.smoking = value
    }
    func setDistancePreference(value: String) {
        structUserDetailsValue.distancePreference = value
    }
    
    func setUserProfileCollection(value: [UserProfileImages]) {
        structUserDetailsValue.profileCollection = value
    }
    
    func setFavoriteActivity(value: [UserInterestedCategory]) {
        structUserDetailsValue.favoriteActivity = value
    }
    
    func removeFavoriteActivityCategoryArray() {
        structUserDetailsValue.favoriteCategoryActivity.removeAll()
    }
    
    func setFavoriteCategoryActivity(value: UserInterestedCategory) {
        structUserDetailsValue.favoriteCategoryActivity.append(value)
    }
}
