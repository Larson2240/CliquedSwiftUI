//
//  ActivityDetailsViewModel.swift
//  Cliqued
//
//  Created by C211 on 24/03/23.
//

import UIKit

class ActivityDetailsViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isMarkStatusDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variable
    private var isDataLoad: Bool = false
    var objActivityDetails : UserActivityClass?
    var arrayOfInterestedUserList = [InterestedUserInfo]()
    
    private struct structActivityDetails {
        var activityId = ""
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
    }
    private var structUserActivityDetailsValue = userActivityDetailsParams()
    
    //MARK: Bind data on screen from the activity object.
    func bindActivityDetailsData(activityDetails: UserActivityClass) {
        
        let activityId = "\(activityDetails.id ?? 0)"
        let userProfile = activityDetails.userProfile ?? ""
        let categoryName = activityDetails.activityCategoryTitle ?? ""
        let activityDate = activityDetails.activityDate ?? ""
        let activityDescription = activityDetails.descriptionValue ?? ""
        
        self.setActivityId(value: activityId)
        self.setUserProfileUrl(value: userProfile)
        self.setCategoryName(value: categoryName)
        self.setDate(value: activityDate)
        self.setDescription(value: activityDescription)
        
        if let arr = activityDetails.activityMedia, arr.count > 0 {
            let img = arr[0].url ?? ""
            let strUrl = UrlUserActivity + img
            self.setImageUrl(value: strUrl)
        }
        
        if let arrAddress = activityDetails.activityDetails,arrAddress.count > 0 {
            let obj = arrAddress[0]
            let address = obj.address ?? ""
            self.setLocation(value: address)
        }
    }
    
    //MARK: Call API
    func callInterestedActivityListAPI() {
        
        let params: NSDictionary = [
            APIParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            APIParams.activityId: self.getActivityId()
        ]
        
        if(Connectivity.isConnectedToInternet()){
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetActivityInterestedPeople, parameters: params) { response, error, message in
                self.isDataLoad = true
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    
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
    
}
//MARK: getter/setter method
extension ActivityDetailsViewModel {
    
    func getActivityId() -> String {
        structActivityDetailsValue.activityId
    }
    func setActivityId(value: String) {
        structActivityDetailsValue.activityId = value
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
    
    //Array Methods
    func getNumberOfInterestedUser() -> Int {
        arrayOfInterestedUserList.count
    }
    func getInterestedUserData(at index: Int) -> InterestedUserInfo? {
        arrayOfInterestedUserList[index]
    }
    func getAllInterestedUserData() -> [InterestedUserInfo] {
        arrayOfInterestedUserList
    }
    func removeInterestedActivityData(at Index: Int) {
        arrayOfInterestedUserList.remove(at: Index)
    }
    
    func addInterestedActivityData(at Index: Int, obj:InterestedUserInfo?) {
        arrayOfInterestedUserList.insert(obj!, at: Index)
    }
    
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrayOfInterestedUserList.count  == 0 {
            return true
        } else {
            return false
        }
    }
}
