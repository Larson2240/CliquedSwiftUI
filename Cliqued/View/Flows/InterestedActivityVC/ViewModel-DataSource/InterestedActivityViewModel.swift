//
//  InterestedActivityViewModel.swift
//  Cliqued
//
//  Created by C211 on 22/02/23.
//

import UIKit

class InterestedActivityViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isViewLimitFinish: Dynamic<Bool> = Dynamic(false)
    var isLikeLimitFinish: Dynamic<Bool> = Dynamic(false)
    var isLikdDislikeSuccess: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variable
    private var isDataLoad: Bool = false
    private var likesLimit: Int = 0
    var arrayOfInterestedUserList = [InterestedUserInfo]()
    var arrayOfDuplicateInterestedUserList = [InterestedUserInfo]()
    var arrayOfFollowersList = [Followers]()
    
    private var activity_id = ""
    private var interested_user_id = ""
    private var is_follow = ""
    private var activty_title = ""
    private let apiParams = ApiParams()
    
    //MARK: Call API
    func callInterestedActivityListAPI() {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.activityId: self.getActivityId()
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                self?.isLoaderShow.value = true
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetActivityInterestedPeople, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
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
                        if let activityArray = json?["activity"] as? NSArray {
                            if activityArray.count > 0 {
                                let dicActivity = activityArray[0] as! NSDictionary
                                let userArray = dicActivity["user_info"] as! NSArray
                                if userArray.count > 0 {
                                    for userInfo in userArray {
                                        let dicUser = userInfo as! NSDictionary
                                        let decoder = JSONDecoder()
                                        do {
                                            let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                            let objUser = try decoder.decode(InterestedUserInfo.self, from: jsonData)
                                            self.arrayOfInterestedUserList.append(objUser)
                                            self.arrayOfDuplicateInterestedUserList.append(objUser)
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                    self.isDataGet.value = true
                                } else {
                                    self.isDataGet.value = true
                                }
                            }
                        }
                    } else if status == LIMIT_FINISH {
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
    
    //MARK: Call like dislike activity API
    func callLikeDislikeActivityAPI(isShowLoader: Bool) {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.activityId : self.getActivityId(),
            apiParams.interestedUserId : self.getInterestedUserId(),
            apiParams.isFollow : self.getIsFollow(),
            apiParams.activityName : self.getActivityTitle()
        ]
        
        if(Connectivity.isConnectedToInternet()) {
            DispatchQueue.main.async { [weak self] in
                if isShowLoader {
                    self?.isLoaderShow.value = true
                }
            }
            self.arrayOfFollowersList.removeAll()
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.MarkActivityInterestForUser, parameters: params) { [weak self] response, error, message in
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
                    } else if status == 2 {
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
extension InterestedActivityViewModel {
    
    //Set Methods
    func setActivityId(value:String) {
        activity_id = value
    }
    func setInterestedUserId(value:String) {
        interested_user_id = value
    }
    func setIsFollow(value:String) {
        is_follow = value
    }

    func setActivityTitle(value:String) {
        activty_title = value
    }
    

    //Get Mothods
    func getActivityId() -> String {
        activity_id
    }
    func getInterestedUserId() -> String {
        interested_user_id
    }
    func getIsFollow() -> String {
        is_follow
    }
    
    func getActivityTitle() -> String {
        activty_title
    }
    
    //Array Methods
    func getNumberOfInterestedUser() -> Int {
        arrayOfDuplicateInterestedUserList.count
    }
    func getInterestedUserData(at index: Int) -> InterestedUserInfo? {
        arrayOfDuplicateInterestedUserList[index]
    }
    func getAllInterestedUserData() -> [InterestedUserInfo] {
        arrayOfDuplicateInterestedUserList
    }
    func removeInterestedActivityData(at Index: Int) {
        arrayOfDuplicateInterestedUserList.remove(at: Index)
    }
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrayOfDuplicateInterestedUserList.count  == 0 {
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
}
