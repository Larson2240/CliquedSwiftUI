//
//  HomeActivitiesViewModel.swift
//  Cliqued
//
//  Created by C211 on 18/01/23.
//

import UIKit

class HomeActivitiesViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isViewLimitFinish: Dynamic<Bool> = Dynamic(false)
    var isLikeLimitFinish: Dynamic<Bool> = Dynamic(false)
    var isLikdDislikeSuccess: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variable
    private var isDataLoad: Bool = false
    private var likesLimit: Int = 0
    var arrayOfMainUserList = [User]()
    var arrayOfDuplicateUserList = [User]()
    var arrayOfUndoUserList = [User]()
    private var recordsCount: Int = 0
    var arrayOfFollowersList = [Followers]()
    var offset = 0
    
    private var isRefresh: Bool = false
    private let apiParams = ApiParams()
    
    private struct GetUserActivityParams {
        var activityId = ""
        var activitySubCatIds = ""
        var loogkingForIds = ""
        var kidsOptionId = ""
        var smokingOptionId = ""
        var agetStartPrefId = ""
        var agetEndPrefId = ""
        var distancePrefId = ""
        var user_ids = ""
    }
    private var structUserActivityParamValue = GetUserActivityParams()
    
    private struct setFollowStatusParams {
        var counterUserId = ""
        var isFollow = ""
    }
    private var structFollowStatusParamValue = setFollowStatusParams()
    
    //MARK: Call Get Preferences Data API
    func callGetUserActivityAPI() {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.activityId : self.getActivityId(),
            apiParams.activitySubCategoryId : self.getActivitySubCatIds(),
            apiParams.looking_for : self.getLookingForIds(),
            apiParams.kids_option_id : self.getKidsOptionId(),
            apiParams.smoking_option_id : self.getSmokingOptionId(),
            apiParams.ageStartPrefId : self.getAgeStartPrefId(),
            apiParams.ageEndPrefId : self.getAgeEndPrefId(),
            apiParams.distancePrefId : self.getDistancePrefId(),
            apiParams.offset : self.getOffset(),
            apiParams.userIds : self.getUserIds()
        ]
        
        if(Connectivity.isConnectedToInternet()) {
            DispatchQueue.main.async { [weak self] in
                self?.isLoaderShow.value = true
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUsersForActivity, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.isDataLoad = true
                self.isLoaderShow.value = false
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    let recordCount = json?["record_limit"] as? Int
                    let likesLimit = json?["likes_limit"] as? Int
                    self.setLikesLimit(value: likesLimit ?? 0)
                    self.setRecordsCount(value: recordCount ?? 0)
                    if status == SUCCESS {
                        if let activityArray = json?["user_list"] as? NSArray {
                            if activityArray.count > 0 {
                                for activityInfo in activityArray {
                                    let dicActivity = activityInfo as! NSDictionary
                                    let decoder = JSONDecoder()
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject:dicActivity)
                                        let activityData = try decoder.decode(User.self, from: jsonData)
                                        self.arrayOfMainUserList.append(activityData)
                                        self.arrayOfDuplicateUserList.append(activityData)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                                self.isDataGet.value = true
                            } else {
                                self.isDataGet.value = true
                            }
                        }
                    } else if status == 2 {
                        self.isDataGet.value = true
                        self.isViewLimitFinish.value = true
                        self.isMessage.value = message ?? ""
                    } else {
                        self.isMessage.value = message ?? ""
                        self.isDataGet.value = true
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    //MARK: Call Like Dislike profile API
    func callLikeDislikeUserAPI(isShowLoader: Bool) {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.counterUserId : self.getCounterUserId(),
            apiParams.isFollow : self.getIsFollow()
        ]
        
        if(Connectivity.isConnectedToInternet()) {
            DispatchQueue.main.async { [weak self] in
                if isShowLoader {
                    self?.isLoaderShow.value = true
                }
            }
            self.arrayOfFollowersList.removeAll()
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.SetUserFollowStatus, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.isLoaderShow.value = false
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    if status == SUCCESS {
                        if let followersArray = json?["followers"] as? NSArray {
                            if followersArray.count > 0 {
                                for followersInfo in followersArray {
                                    let dicFollowers = followersInfo as! NSDictionary
                                    let decoder = JSONDecoder()
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject:dicFollowers)
                                        let followersData = try decoder.decode(Followers.self, from: jsonData)
                                        self.arrayOfFollowersList.append(followersData)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                                self.isLikdDislikeSuccess.value = true
                            } else {
                                self.isLikdDislikeSuccess.value = true
                            }
                        }
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
//MARK: getter/setter method
extension HomeActivitiesViewModel {
    
    //Set Methods
    func setUserIds(value:String) {
        structUserActivityParamValue.user_ids = value
    }
    func setActivityId(value:String) {
        structUserActivityParamValue.activityId = value
    }
    func setActivitySubCatIds(value:String) {
        structUserActivityParamValue.activitySubCatIds = value
    }
    func setLookingForIds(value:String) {
        structUserActivityParamValue.loogkingForIds = value
    }
    func setKidsOptionId(value:String) {
        structUserActivityParamValue.kidsOptionId = value
    }
    func setSmokingOptionId(value:String) {
        structUserActivityParamValue.smokingOptionId = value
    }
    func setAgeStartPrefId(value:String) {
        structUserActivityParamValue.agetStartPrefId = value
    }
    func setAgeEndPrefId(value:String) {
        structUserActivityParamValue.agetEndPrefId = value
    }
    func setDistancePrefId(value:String) {
        structUserActivityParamValue.distancePrefId = value
    }
    func setRecordsCount(value:Int) {
        recordsCount = value
    }
    func getRecordsCount() -> Int {
        recordsCount
    }
    
    //Get Mothods
    func getUserIds() -> String {
        structUserActivityParamValue.user_ids
    }
    func getActivityId() -> String {
        structUserActivityParamValue.activityId
    }
    func getActivitySubCatIds() -> String {
        structUserActivityParamValue.activitySubCatIds
    }
    func getLookingForIds() -> String {
        structUserActivityParamValue.loogkingForIds
    }
    func getKidsOptionId() -> String {
        structUserActivityParamValue.kidsOptionId
    }
    func getSmokingOptionId() -> String {
        structUserActivityParamValue.smokingOptionId
    }
    func getAgeStartPrefId() -> String {
        structUserActivityParamValue.agetStartPrefId
    }
    func getAgeEndPrefId() -> String {
        structUserActivityParamValue.agetEndPrefId
    }
    func getDistancePrefId() -> String {
        structUserActivityParamValue.distancePrefId
    }
    

    //Main Array Methods
    func getNumberOfUserActivity() -> Int {
        arrayOfMainUserList.count
    }
    func getUserActivityData(at index: Int) -> User {
        arrayOfMainUserList[index]
    }
    func getAllUserActivityData() -> [User] {
        arrayOfMainUserList
    }
    func isCheckEmptyMainUserData() -> Bool {
        if isDataLoad && arrayOfMainUserList.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    
    //Duplicate Array Methods
    func getNumberOfDuplicateUserActivity() -> Int {
        arrayOfDuplicateUserList.count
    }
    func getDuplicateUserActivityData(at index: Int) -> User {
        arrayOfDuplicateUserList[index]
    }
    func getAllDuplicationUserActivityData() -> [User] {
        arrayOfDuplicateUserList
    }
    func removeDuplicateUserActivityData(at Index: Int) {
        arrayOfDuplicateUserList.remove(at: Index)
    }
    func insertDuplicateUserActivityData(data: User, at Index: Int) {
        arrayOfDuplicateUserList.insert(data, at: Index)
    }
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrayOfDuplicateUserList.count  == 0 {
            return true
        } else {
            return false
        }
    }
    
    func getIsRefresh() -> Bool {
        return isRefresh
    }
    
    func setIsRefresh(value:Bool) {
        isRefresh = value
    }
    
    func getFollowersData(at index: Int) -> Followers {
        return arrayOfFollowersList[index]
    }
    func getAllFollowersData() -> [Followers] {
        return arrayOfFollowersList
    }
    
    func setCounterUserId(value:String) {
        structFollowStatusParamValue.counterUserId = value
    }
    func setIsFollow(value:String) {
        structFollowStatusParamValue.isFollow = value
    }
    
    func getCounterUserId() -> String {
        return structFollowStatusParamValue.counterUserId
    }
    func getIsFollow() -> String {
        return structFollowStatusParamValue.isFollow
    }
    
    
    func setUndoUserList(value: User) {
        arrayOfUndoUserList.append(value)
    }
    func getAllUndoUserList() -> [User] {
        return arrayOfUndoUserList
    }
    
    func setOffset() {
        offset = offset + 1
    }
    func getOffset() -> Int {
        return offset
    }
    
    func setLikesLimit(value: Int) {
        likesLimit = value
    }
    func getLikesLimit() -> Int {
        return likesLimit
    }
}
