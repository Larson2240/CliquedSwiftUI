//
//  ActivityUserDetailsViewModel.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit

class ActivityUserDetailsViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    var isDataLoad: Bool = false
    private let apiParams = ApiParams()
    private let preferenceTypeIds = PreferenceTypeIds()
    private let isBlock = Block()
    
    //MARK: Variable
    private struct activityUserDetails {
        var id = ""
        var profileCollection = [UserProfileImages]()
        var name = ""
        var age = ""
        var distance = ""
        var aboutme = ""
        var favoriteActivity = [UserInterestedCategory]()
        var favoriteCategoryActivity = [UserInterestedCategory]()
        var loogkingFor = ""
        var location = [UserAddress]()
        var height = ""
        var kids = ""
        var smoking = ""
    }
    private var structActivityUserDetailsValue = activityUserDetails()
    
    //MARK: Bind data on screen from the user object.
    func bindActivityUserDetailsData(userData: User) {
        self.setActivityUserId(value: "\(userData.id ?? 0)")
        self.setName(value: userData.name ?? "")
        
//        self.setName(value: "\(userData.name ?? "") - \(userData.gender == "1" ? "Male" : "Female")")
        self.setAge(value: "\(userData.age ?? 0)")
        
       /*
        if userData.userPreferences?.count ?? 0 > 0 {
            var arrayOfPreference = [UserPreferences]()
            arrayOfPreference = userData.userPreferences ?? []
            
            var strTypes = ""
            
            let arrFriendship = arrayOfPreference.filter({$0.typesOfPreference == PreferenceTypeIds.friendship})
          
            for obj in arrFriendship {
                if strTypes.isEmpty {
                    strTypes = obj.preferenceOptionTitle!
                } else {
                    strTypes = "\(strTypes),\(obj.preferenceOptionTitle ?? "")"
                }
            }
            
            let arrRomance = arrayOfPreference.filter({$0.typesOfPreference == PreferenceTypeIds.romance})
            
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
                 
        
        self.setLookingFor(value: "\(userData.lookingForTitle ?? "")")
        
       
    }
    
    //MARK: Call SignIn API
    func callBlcokUserAPI(counterUserId: String) {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.counterUserId : counterUserId,
            apiParams.isBlock : isBlock.Block,
            apiParams.blockType : "0"
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                self?.isLoaderShow.value = true
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.BlcokUser, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.isLoaderShow.value = false
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        self.isDataGet.value = true
                        self.isMessage.value = message ?? ""
                    }  else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
}
//MARK: getter/setter method
extension ActivityUserDetailsViewModel {
    
    func getActivityUserId() -> String {
        structActivityUserDetailsValue.id
    }
    func getName() -> String {
        structActivityUserDetailsValue.name
    }
    func getAge() -> String {
        structActivityUserDetailsValue.age
    }
    func getDistance() -> String {
        structActivityUserDetailsValue.distance
    }
    func getAboutMe() -> String {
        structActivityUserDetailsValue.aboutme
    }
    func getLookingFor() -> String {
        structActivityUserDetailsValue.loogkingFor
    }
    func getLocation() -> [UserAddress] {
        structActivityUserDetailsValue.location
    }
    func getHeight() -> String {
        structActivityUserDetailsValue.height
    }
    func getKids() -> String {
        structActivityUserDetailsValue.kids
    }
    func getSmoking() -> String {
        structActivityUserDetailsValue.smoking
    }
    
    func isCheckProfileImage() -> Bool {
        if structActivityUserDetailsValue.profileCollection.count == 0 {
            return true
        } else {
            return false
        }
    }
    func getNumberOfUserProfile() -> Int {
        structActivityUserDetailsValue.profileCollection.count
    }
    func getUserProfileData(at Index: Int) -> UserProfileImages {
        structActivityUserDetailsValue.profileCollection[Index]
    }
    
    func getNumberOfFavoriteActivity() -> Int {
        structActivityUserDetailsValue.favoriteActivity.count
    }
    func getFavoriteActivity() -> [UserInterestedCategory] {
        structActivityUserDetailsValue.favoriteActivity
    }
    func getFavoriteCategoryActivity() -> [UserInterestedCategory] {
        structActivityUserDetailsValue.favoriteCategoryActivity
    }
    
    func setActivityUserId(value: String) {
        structActivityUserDetailsValue.id = value
    }
    func setName(value: String) {
        structActivityUserDetailsValue.name = value
    }
    func setAge(value: String) {
        structActivityUserDetailsValue.age = value
    }
    func setDistance(value: String) {
        structActivityUserDetailsValue.distance = value
    }
    func setAboutMe(value: String) {
        structActivityUserDetailsValue.aboutme = value
    }
    func setLookingFor(value: String) {
        structActivityUserDetailsValue.loogkingFor = value
    }
    func setLocation(value: [UserAddress]) {
        structActivityUserDetailsValue.location = value
    }
    func setHeight(value: String) {
        structActivityUserDetailsValue.height = value
    }
    func setKids(value: String) {
        structActivityUserDetailsValue.kids = value
    }
    func setSmoking(value: String) {
        structActivityUserDetailsValue.smoking = value
    }
    
    func setUserProfileCollection(value: [UserProfileImages]) {
        structActivityUserDetailsValue.profileCollection = value
    }
    
    func setFavoriteActivity(value: [UserInterestedCategory]) {
        structActivityUserDetailsValue.favoriteActivity = value
    }
    func setFavoriteCategoryActivity(value: UserInterestedCategory) {
        structActivityUserDetailsValue.favoriteCategoryActivity.append(value)
    }
}
