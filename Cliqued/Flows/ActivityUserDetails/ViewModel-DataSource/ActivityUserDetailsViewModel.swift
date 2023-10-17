//
//  ActivityUserDetailsViewModel.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import SwiftUI

class ActivityUserDetailsViewModel {
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
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
        var profileCollection = [UserProfileMedia]()
        var name = ""
        var age = ""
        var distance = ""
        var aboutme = ""
        var favoriteActivity = [Activity]()
        var favoriteCategoryActivity = [Activity]()
        var loogkingFor = ""
        var location: Address?
        var height = ""
        var kids = ""
        var smoking = ""
    }
    private var structActivityUserDetailsValue = activityUserDetails()
    
    //MARK: Bind data on screen from the user object.
    func bindActivityUserDetailsData(userData: User) {
        let lookingFor = "\(loggedInUser?.preferenceRomance != nil ? Constants.btn_romance : "") \(loggedInUser?.preferenceRomance != nil && loggedInUser?.preferenceFriendship != nil ? "& " : "")\(loggedInUser?.preferenceFriendship != nil ? Constants.btn_friendship : "")"
        
        setActivityUserId(value: String(userData.id ?? 0))
        setUserProfileCollection(value: userData.userProfileMedia ?? [])
        setName(value: "\(userData.name ?? "") - \(userData.gender == 1 ? "Male" : "Female")")
        setAge(value: "\(userData.userAge())")
        setDistance(value: String(userData.preferenceDistance ?? 0))
        setAboutMe(value: userData.aboutMe ?? "-")
        setLookingFor(value: "Looking for \(lookingFor)")
        setLocation(value: userData.userAddress)
        setHeight(value: String(userData.height ?? 0))
        setKids(value: userData.preferenceKids == true ? "Yes" : "No")
        setSmoking(value: userData.preferenceSmoking == true ? "Yes" : "No")
        
        if let allActivities = Constants.activityCategories, let userActivities = userData.favouriteActivityCategories {
            let parentActivities = allActivities.filter { $0.parentID == nil }
            var finalActivities: [Activity] = []
            
            for activity in userActivities {
                guard let parentActivity = parentActivities.first(where: { $0.id == activity.parentID }) else { continue }
                
                if !finalActivities.contains(parentActivity) {
                    finalActivities.append(parentActivity)
                }
            }
            
            setFavoriteCategoryActivity(value: finalActivities)
        }
    }
    
    //MARK: Call SignIn API
    func callBlcokUserAPI(counterUserId: String) {
        
//        let params: NSDictionary = [
//            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
//            apiParams.counterUserId : counterUserId,
//            apiParams.isBlock : isBlock.Block,
//            apiParams.blockType : "0"
//        ]
//
//        if(Connectivity.isConnectedToInternet()){
//            DispatchQueue.main.async { [weak self] in
//                self?.isLoaderShow.value = true
//            }
//            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.BlcokUser, parameters: params) { [weak self] response, error, message in
//                guard let self = self else { return }
//
//                self.isLoaderShow.value = false
//                if(error != nil && response == nil) {
//                    self.isMessage.value = message ?? ""
//                } else {
//                    let json = response as? NSDictionary
//                    let status = json?[API_STATUS] as? Int
//                    let message = json?[API_MESSAGE] as? String
//
//                    if status == SUCCESS {
//                        self.isDataGet.value = true
//                        self.isMessage.value = message ?? ""
//                    }  else {
//                        self.isMessage.value = message ?? ""
//                    }
//                }
//            }
//        } else {
//            self.isMessage.value = Constants.alert_InternetConnectivity
//        }
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
    func getLocation() -> Address? {
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
    func getUserProfileData(at Index: Int) -> UserProfileMedia {
        structActivityUserDetailsValue.profileCollection[Index]
    }
    
    func getNumberOfFavoriteActivity() -> Int {
        structActivityUserDetailsValue.favoriteActivity.count
    }
    
    func getFavoriteCategoryActivity() -> [Activity] {
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
    func setLookingFor(value: String) {         structActivityUserDetailsValue.loogkingFor = value
    }
    func setLocation(value: Address?) {
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
    
    func setUserProfileCollection(value: [UserProfileMedia]) {
        structActivityUserDetailsValue.profileCollection = value
    }
    
    func setFavoriteCategoryActivity(value: [Activity]) {
        structActivityUserDetailsValue.favoriteCategoryActivity = value
    }
}
