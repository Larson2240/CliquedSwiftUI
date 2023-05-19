//
//  File.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit

class ActivitiesViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variables
    private struct userActivityListParams {
        var user_id = ""
        var activity_category_id = ""
        var activity_sub_category_id = ""
        var loogkingForIds = ""
        var kidsOptionId = ""
        var smokingOptionId = ""
        var agetStartPrefId = ""
        var agetEndPrefId = ""
        var distancePrefId = ""
    }
    private var structUserActivityValue = userActivityListParams()
    var arrMyActivities = [UserActivityClass]()
    var arrOtherActivities = [UserActivityClass]()
    private var offset = "0"
    private var user_activity_create_count = "0"
    private var other_activity_counter = "0"
    private var isRefresh: Bool = false
    private var isDataLoad: Bool = false
    
    //MARK: Call All Activities API
    func callAllActivityListAPI() {
               
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
                APIParams.offset: self.getOffset()                
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async {
                    self.arrMyActivities.removeAll()
                    self.arrOtherActivities.removeAll()
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetAllActivityList, parameters: params) { response, error, message in
                    self.setIsDataLoad(value: true)
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                        
                        self.setUserActivityCreateCount(value: "\(json?["user_activity_create_count"] as? Int ?? 0)")
                        self.setOtherActivityCounter(value: "\(json?["activity_counter"] as? Int ?? 0)")
                                            
                        if status == SUCCESS {
                            
                            if let userArray = json?["my_activity"] as? NSArray {
                                                               
                                if userArray.count > 0 {
                                    self.arrMyActivities.removeAll()
                                    for userInfo in userArray {
                                        let dicUser = userInfo as! NSDictionary
                                        let decoder = JSONDecoder()
                                        do {
                                            let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                            let objUser = try decoder.decode(UserActivityClass.self, from: jsonData)
                                            self.arrMyActivities.append(objUser)
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            }
                            
                            if let userArray = json?["other_activity"] as? NSArray {
                                if userArray.count > 0 {
                                    self.arrOtherActivities.removeAll()
                                    for userInfo in userArray {
                                        let dicUser = userInfo as! NSDictionary
                                        let decoder = JSONDecoder()
                                        do {
                                            let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                            let objUser = try decoder.decode(UserActivityClass.self, from: jsonData)
                                            self.arrOtherActivities.append(objUser)
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
}


//MARK: getter/setter method
extension ActivitiesViewModel {
    
    //Get methods
    func getUserId() -> String {
        structUserActivityValue.user_id
    }
    
    func getActivityCategoryId() -> String {
        structUserActivityValue.activity_category_id
    }
    
    func getActivitySubCategoryId() -> String {
        structUserActivityValue.activity_sub_category_id
    }
    
    func getLookingForIds() -> String {
        structUserActivityValue.loogkingForIds
    }
    func getKidsOptionId() -> String {
        structUserActivityValue.kidsOptionId
    }
    func getSmokingOptionId() -> String {
        structUserActivityValue.smokingOptionId
    }
    func getAgeStartPrefId() -> String {
        structUserActivityValue.agetStartPrefId
    }
    func getAgeEndPrefId() -> String {
        structUserActivityValue.agetEndPrefId
    }
    func getDistancePrefId() -> String {
        structUserActivityValue.distancePrefId
    }
    
    func getUserActivityCreateCount() -> String {
        user_activity_create_count
    }
    
    func getOtherActivityCounter() -> String {
        other_activity_counter
    }
    
    func getOffset() -> String {
        offset
    }
    
    func getIsRefresh() -> Bool {
        return isRefresh
    }
   
    //Set methods
    func setUserId(value: String) {
        structUserActivityValue.user_id = value
    }
    
    func setActivityCategoryId(value: String) {
        structUserActivityValue.activity_category_id = value
    }
    
    func setActivitySubCategoryId(value: String) {
        structUserActivityValue.activity_sub_category_id = value
    }
    
    func setLookingForIds(value:String) {
        structUserActivityValue.loogkingForIds = value
    }
    func setKidsOptionId(value:String) {
        structUserActivityValue.kidsOptionId = value
    }
    func setSmokingOptionId(value:String) {
        structUserActivityValue.smokingOptionId = value
    }
    func setAgeStartPrefId(value:String) {
        structUserActivityValue.agetStartPrefId = value
    }
    func setAgeEndPrefId(value:String) {
        structUserActivityValue.agetEndPrefId = value
    }
    func setDistancePrefId(value:String) {
        structUserActivityValue.distancePrefId = value
    }
    
    func setUserActivityCreateCount(value: String) {
        user_activity_create_count = value
    }
    
    func setOtherActivityCounter(value: String) {
        other_activity_counter = value
    }
    
    func setOffset(value: String) {
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
}
