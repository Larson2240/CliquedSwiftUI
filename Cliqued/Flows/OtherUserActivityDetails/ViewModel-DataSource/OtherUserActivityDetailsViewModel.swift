//
//  OtherUserDetailsViewModel.swift
//  Cliqued
//
//  Created by C211 on 24/01/23.
//

import UIKit

class OtherUserActivityDetailsViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isMarkStatusDataGet: Dynamic<Bool> = Dynamic(false)
    var isUserDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variables
    //MARK: Variable
    private struct structActivityDetails {
        var categoryName = ""
        var imageUrl = ""
        var userProfileUrl = ""
        var date = ""
        var description = ""
        var location = ""
    }
    private var structActivityDetailsValue = structActivityDetails()
    
    private struct userActivityDetailsParams {
        var user_id = ""
        var activity_id = ""
        var is_interested = ""
        var owner_id = ""
        var activity_name = ""
    }
    private var structUserActivityDetailsValue = userActivityDetailsParams()
    private var likeStatus: Int?
    var arrActivityDetails = [UserActivityClass]()
    var objActivityDetails : UserActivityClass?
    var arrayOfMainUserList = [User]()
    var activity_owner_id = 0
    private let apiParams = ApiParams()
    
    //MARK: Check Validation
    func checkValidation() -> Bool {
        var flag = false
        
        if getUserId().isEmpty {
            self.isMessage.value = Constants_Message.user_id_validation
        } else if getActivityId().isEmpty {
            self.isMessage.value = Constants_Message.activity_id_validation
        } else {
            flag = true
        }
        return flag
    }
    
    //MARK: Call All Activities API
    func callGetUserDetailsAPI(user_id: Int) {
        
        let params: NSDictionary = [
            apiParams.userID : user_id
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.isLoaderShow.value = true
                self.arrayOfMainUserList.removeAll()
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
                                    self.arrayOfMainUserList.append(objUser)
                                    self.isUserDataGet.value = true
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
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    func callActivityDetailsAPI() {
        
        let params: NSDictionary = [
            apiParams.userID : self.getUserId(),
            apiParams.activityId : self.getActivityId()
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.isLoaderShow.value = true
                self.arrActivityDetails.removeAll()
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetActivityDetails, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.isLoaderShow.value = false
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        
                        if let userArray = json?["user_activity"] as? NSArray {
                            if userArray.count > 0 {
                                for userInfo in userArray {
                                    let dicUser = userInfo as! NSDictionary
                                    let decoder = JSONDecoder()
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                        let objUser = try decoder.decode(UserActivityClass.self, from: jsonData)
                                        self.arrActivityDetails.append(objUser)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                        
                        if (self.arrActivityDetails.count > 0) {
                            self.objActivityDetails = self.arrActivityDetails[0]
                        }
                        
                        self.isDataGet.value = true
                    } else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    //MARK: Bind data on screen from the user object.
    func bindActivityDetailsData(activityDetails: UserActivityClass) {
        
        let userProfile = activityDetails.user
        let categoryName = activityDetails.title
        let activityDate = activityDetails.activityDate
        let activityDescription = activityDetails.description
        
        
        self.setUserProfileUrl(value: userProfile)
        self.setCategoryName(value: categoryName)
        self.setDate(value: activityDate)
        self.setDescription(value: activityDescription)
        
        activity_owner_id = Int(activityDetails.user) ?? 0
        self.setOwnerId(value: "\(activity_owner_id)")
        self.setActivityName(value: activityDetails.title)
        
        if activityDetails.medias.count > 0 {
            let img = activityDetails.medias[0]
            self.setImageUrl(value: "https://cliqued.michal.es" + img.url)
        }
        
        let address = activityDetails.address
        self.setLocation(value: address)
    }
    
    func callMarkActivityStatusAPI() {
        
        if checkValidation() {
            let params: NSDictionary = [
                apiParams.interestedUserId : self.getUserId(),
                apiParams.activityId : self.getActivityId(),
                apiParams.isFollow : self.getActivityInterestStatus(),
                apiParams.ownerId : self.getOwnerId(),
                apiParams.activityName : self.getActivityName()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async { [weak self] in
                    self?.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.MarkUserActivityAsInterested, parameters: params) { [weak self] response, error, message in
                    guard let self = self else { return }
                    
                    self.isLoaderShow.value = false
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                        let likeStatus = json?["like_status"] as? Int
                        self.setLikesStatus(value: likeStatus ?? -1)
                        
                        if status == SUCCESS {
//                            self.isMessage.value = message ?? ""
                            self.isMarkStatusDataGet.value = true
                        } else {
                            self.isMessage.value = message ?? ""
                        }
                    }
                }
            } else {
                self.isMessage.value = Constants.alert_InternetConnectivity
            }
        }
    }
}

//MARK: getter/setter method
extension OtherUserActivityDetailsViewModel {
    
    //Get methods
    func getUserId() -> String {
        structUserActivityDetailsValue.user_id
    }
    
    func getActivityId() -> String {
        structUserActivityDetailsValue.activity_id
    }
    
    func getActivityInterestStatus() -> String {
        structUserActivityDetailsValue.is_interested
    }
    
    func getOwnerId() -> String {
        structUserActivityDetailsValue.owner_id
    }
    
    func getActivityName() -> String {
        structUserActivityDetailsValue.activity_name
    }
    
    
    //Set methods
    func setUserId(value: String) {
        structUserActivityDetailsValue.user_id = value
    }
    
    func setActivityId(value: String) {
        structUserActivityDetailsValue.activity_id = value
    }
    
    func setActivityInterestStatus(value: String) {
        structUserActivityDetailsValue.is_interested = value
    }
    
    func setOwnerId(value: String) {
        structUserActivityDetailsValue.owner_id = value
    }
    
    func setActivityName(value: String) {
        structUserActivityDetailsValue.activity_name = value
    }
    
    
    func getCategoryName() -> String {
        structActivityDetailsValue.categoryName
    }
    func setCategoryName(value: String) {
        structActivityDetailsValue.categoryName = value
    }
    
    func getImageUrl() -> String {
        structActivityDetailsValue.imageUrl
    }
    func setImageUrl(value: String) {
        structActivityDetailsValue.imageUrl = value
    }
    
    func getUserProfileUrl() -> String {
        structActivityDetailsValue.userProfileUrl
    }
    func setUserProfileUrl(value: String) {
        structActivityDetailsValue.userProfileUrl = value
    }
    
    func getDate() -> String {
        structActivityDetailsValue.date
    }
    func setDate(value: String) {
        structActivityDetailsValue.date = value
    }
    
    func getDescription() -> String {
        structActivityDetailsValue.description
    }
    func setDescription(value: String) {
        structActivityDetailsValue.description = value
    }
    
    func getLocation() -> String {
        structActivityDetailsValue.location
    }
    func setLocation(value: String) {
        structActivityDetailsValue.location = value
    }
    
    func setLikesStatus(value: Int) {
        likeStatus = value
    }
    func getLikesStatus() -> Int {
        return likeStatus ?? -1
    }
}


