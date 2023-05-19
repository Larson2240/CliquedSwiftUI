//
//  DiscoverActivityViewModel.swift
//  Cliqued
//
//  Created by C100-132 on 03/02/23.
//

import Foundation

class DiscoverActivityViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isMarkStatusDataGet: Dynamic<Bool> = Dynamic(false)
    var isLikeLimitFinish: Dynamic<Bool> = Dynamic(false)
    var isUserDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variables
    private struct otherUserActivityListParams {
        var user_id = ""
        var activity_category_id = ""
        var activity_sub_category_id = ""
        var activity_id = ""
        var is_interested = ""
        var loogkingForIds = ""
        var kidsOptionId = ""
        var smokingOptionId = ""
        var agetStartPrefId = ""
        var agetEndPrefId = ""
        var distancePrefId = ""
        var owner_id = ""
        var activity_name = ""
    }
    private var structOtherUserActivityValue = otherUserActivityListParams()
    var arrOtherActivities = [UserActivityClass]()
    var arrOtherActivitiesDuplicate = [UserActivityClass]()
    private var offset = 0
    private var likeStatus: Int?
    private var likesLimit: Int = 0
    private var isRefresh: Bool = false
    private var isDataLoad: Bool = false
    var arrayOfMainUserList = [User]()
    
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
    func callMarkActivityStatusAPI() {
        
        if checkValidation() {
            let params: NSDictionary = [
                APIParams.interestedUserId : self.getUserId(),
                APIParams.activityId : self.getActivityId(),
                APIParams.isFollow : self.getActivityInterestStatus(),
                APIParams.ownerId : self.getOwnerId(),
                APIParams.activityName : self.getActivityName()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.MarkUserActivityAsInterested, parameters: params) { response, error, message in
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
                        } else if status == LIMIT_FINISH {
                            self.isLikeLimitFinish.value = true
                            self.isMessage.value = message ?? ""
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
    
    func callActivityListAPI() {
               
            let params: NSDictionary = [
                APIParams.userID : self.getUserId(),
                APIParams.activityCategoryId: self.getActivityCategoryId(),
                APIParams.activitySubCategoryId: self.getActivitySubCategoryId(),
                APIParams.looking_for : self.getLookingForIds(),
                APIParams.kids_option_id : self.getKidsOptionId(),
                APIParams.smoking_option_id : self.getSmokingOptionId(),
                APIParams.ageStartPrefId : self.getAgeStartPrefId(),
                APIParams.ageEndPrefId : self.getAgeEndPrefId(),
                APIParams.distancePrefId : self.getDistancePrefId(),
                APIParams.offset: self.getOffset(),
                APIParams.isOwnActivity : "0"
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async {
                    self.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUserActivity, parameters: params) { response, error, message in
                    self.setIsDataLoad(value: true)
                    self.isLoaderShow.value = false
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                        let likesLimit = json?["likes_limit"] as? Int
                        self.setLikesLimit(value: likesLimit ?? 0)
                        if status == SUCCESS {
                            
                            if let userArray = json?["user_activity"] as? NSArray {
                                if userArray.count > 0 {
                                    for userInfo in userArray {
                                        let dicUser = userInfo as! NSDictionary
                                        let decoder = JSONDecoder()
                                        do {
                                            let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                            let objUser = try decoder.decode(UserActivityClass.self, from: jsonData)
                                            self.arrOtherActivities.append(objUser)
                                            self.arrOtherActivitiesDuplicate.append(objUser)
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
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
    
    //MARK: Call All Activities API
    func callGetUserDetailsAPI(user_id: Int) {
        
        let params: NSDictionary = [
            APIParams.userID : user_id
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async {
                self.isLoaderShow.value = true
                self.arrayOfMainUserList.removeAll()
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUserDetails, parameters: params) { response, error, message in
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
}

//MARK: getter/setter method
extension DiscoverActivityViewModel {
    
    //Get methods
    func getUserId() -> String {
        structOtherUserActivityValue.user_id
    }
    
    func getActivityCategoryId() -> String {
        structOtherUserActivityValue.activity_category_id
    }
    
    func getActivitySubCategoryId() -> String {
        structOtherUserActivityValue.activity_sub_category_id
    }
    
    func getActivityId() -> String {
        structOtherUserActivityValue.activity_id
    }
    
    func getActivityInterestStatus() -> String {
        structOtherUserActivityValue.is_interested
    }
    
    func getLookingForIds() -> String {
        structOtherUserActivityValue.loogkingForIds
    }
    func getKidsOptionId() -> String {
        structOtherUserActivityValue.kidsOptionId
    }
    func getSmokingOptionId() -> String {
        structOtherUserActivityValue.smokingOptionId
    }
    func getAgeStartPrefId() -> String {
        structOtherUserActivityValue.agetStartPrefId
    }
    func getAgeEndPrefId() -> String {
        structOtherUserActivityValue.agetEndPrefId
    }
    func getDistancePrefId() -> String {
        structOtherUserActivityValue.distancePrefId
    }
    
    func getOwnerId() -> String {
        structOtherUserActivityValue.owner_id
    }
    
    func getActivityName() -> String {
        structOtherUserActivityValue.activity_name
    }
    
    func getOffset() -> Int {
        offset
    }
    
    func getIsRefresh() -> Bool {
        return isRefresh
    }
   
    //Set methods
    func setUserId(value: String) {
        structOtherUserActivityValue.user_id = value
    }
    
    func setActivityCategoryId(value: String) {
        structOtherUserActivityValue.activity_category_id = value
    }
    
    func setActivitySubCategoryId(value: String) {
        structOtherUserActivityValue.activity_sub_category_id = value
    }
    
    func setActivityId(value: String) {
        structOtherUserActivityValue.activity_id = value
    }
    
    func setActivityInterestStatus(value: String) {
        structOtherUserActivityValue.is_interested = value
    }
    
    func setLookingForIds(value:String) {
        structOtherUserActivityValue.loogkingForIds = value
    }
    func setKidsOptionId(value:String) {
        structOtherUserActivityValue.kidsOptionId = value
    }
    func setSmokingOptionId(value:String) {
        structOtherUserActivityValue.smokingOptionId = value
    }
    func setAgeStartPrefId(value:String) {
        structOtherUserActivityValue.agetStartPrefId = value
    }
    func setAgeEndPrefId(value:String) {
        structOtherUserActivityValue.agetEndPrefId = value
    }
    func setDistancePrefId(value:String) {
        structOtherUserActivityValue.distancePrefId = value
    }
    
    func setOwnerId(value:String) {
        structOtherUserActivityValue.owner_id = value
    }
    
    func setActivityName(value:String) {
        structOtherUserActivityValue.activity_name = value
    }
    
    func setOffset(value: Int) {
        offset = value
    }
    
    func setIsRefresh(value:Bool) {
        isRefresh = value
    }
    
    func getIsDataLoad() -> Bool {
        return isDataLoad
    }
    func setIsDataLoad(value: Bool) {
        isDataLoad = value
    }
    
    
    //Duplicate Array Methods
    func getNumberOfDuplicateOtherActivity() -> Int {
        arrOtherActivitiesDuplicate.count
    }
    func getDuplicateOtherActivityData(at index: Int) -> UserActivityClass {
        arrOtherActivitiesDuplicate[index]
    }
    func getAllDuplicationOhterActivityData() -> [UserActivityClass] {
        arrOtherActivitiesDuplicate
    }
    func removeDuplicateOtherActivityData(at Index: Int) {
        arrOtherActivitiesDuplicate.remove(at: Index)
    }
    func insertDuplicateOtherActivityData(data: UserActivityClass, at Index: Int) {
        arrOtherActivitiesDuplicate.insert(data, at: Index)
    }
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrOtherActivitiesDuplicate.count  == 0 {
            return true
        } else {
            return false
        }
    }
    
    func setLikesLimit(value: Int) {
        likesLimit = value
    }
    func getLikesLimit() -> Int {
        return likesLimit
    }
    
    func setLikesStatus(value: Int) {
        likeStatus = value
    }
    func getLikesStatus() -> Int {
        return likeStatus ?? -1
    }
}
