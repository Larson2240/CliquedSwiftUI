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
    
    private let apiParams = ApiParams()
    
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
    
    private let activityWebService = ActivityWebService()
    
    //MARK: Call All Activities API
    func callAllActivityListAPI() {
        guard Connectivity.isConnectedToInternet() else {
            isMessage.value = Constants.alert_InternetConnectivity
            return
        }
        
        activityWebService.getUserActivities { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let activities):
                self.setUserActivityCreateCount(value: "\(activities.count)")
                self.arrMyActivities = activities
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            self.isDataLoad = true
            self.isDataGet.value = true
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
