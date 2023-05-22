//
//  PickSubActivityViewModel.swift
//  Cliqued
//
//  Created by C211 on 07/02/23.
//

import UIKit

struct structPickSubActivityParams {
    var activityCategoryId = ""
    var activitySubCategoryId = ""
}

class PickSubActivityViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isActivityDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variable
    private var isDataLoad: Bool = false
    var arrayOfActivity = [ActivityCategoryClass]()
    var arrayOfActivityAllData = [ActivityCategoryClass]()
    private var arrayOfSelectedSubActivity = [structPickSubActivityParams]()
    private var arrayOfNewSelectedSubActivity = [structPickSubActivityParams]()
    private var arrayOfAllSelectedSubActivity = [structPickSubActivityParams]()
    private var arrayOfDeletedSubActivityIds = [Int]()
    private var categoryIds: String = ""
    private let apiParams = ApiParams()
    
    //MARK: Call Get Preferences Data API
    func callGetActivityDataAPI() {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.activityCategoryId : self.getCategoriesIds()
        ]
        
        if(Connectivity.isConnectedToInternet()) {
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetActivityCategory, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.setIsDataLoad(value: true)
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    _ = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        if let activityArray = json?["activity_category"] as? NSArray {
                            if activityArray.count > 0 {
                                for activityInfo in activityArray {
                                    let dicActivity = activityInfo as! NSDictionary
                                    let decoder = JSONDecoder()
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject:dicActivity)
                                        let activityData = try decoder.decode(ActivityCategoryClass.self, from: jsonData)
                                        self.arrayOfActivity.append(activityData)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                                self.setActivityAllData(value: self.arrayOfActivity)
                                self.isActivityDataGet.value = true
                            } else {
                                self.isActivityDataGet.value = true
                            }
                        }
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
}
//MARK: getter/setter method
extension PickSubActivityViewModel {
    
    //Get method's
    func getNumberOfActivity() -> Int {
        arrayOfActivity.count
    }
    func getActivityAllData() -> [ActivityCategoryClass] {
        arrayOfActivity
    }
    func getActivityData(at index: Int) -> ActivityCategoryClass {
        arrayOfActivity[index]
    }
    func getSelectedSubActivity() -> [structPickSubActivityParams] {
        arrayOfSelectedSubActivity
    }
    func getAllSelectedSubActivity() -> [structPickSubActivityParams] {
        arrayOfAllSelectedSubActivity
    }
    func getNewSelectedSubActivity() -> [structPickSubActivityParams] {
        arrayOfNewSelectedSubActivity
    }
    func getDeletedSubActivityIds() -> [Int] {
        arrayOfDeletedSubActivityIds
    }
    
    
    //Set method's
    func setActivityAllData(value: [ActivityCategoryClass]) {
        arrayOfActivityAllData = value
    }
    func setSubActivity(value: structPickSubActivityParams) {
        arrayOfSelectedSubActivity.append(value)
    }
    func setAllSelectedSubActivity(value: structPickSubActivityParams) {
        arrayOfAllSelectedSubActivity.append(value)
    }
    func setNewSelectedSubActivity(value: structPickSubActivityParams) {
        arrayOfNewSelectedSubActivity.append(value)
    }
    func setDeletedSubActivityIds(value: Int) {
        arrayOfDeletedSubActivityIds.append(value)
    }
    
    func setCategoriesIds(value: String) {
        categoryIds = value
    }
    func getCategoriesIds() -> String {
        categoryIds
    }
    
    //Other method's
    func removeSelectedSubActivity(at Index: Int) {
        arrayOfSelectedSubActivity.remove(at: Index)
    }
    func removeNewSelectedSubActivity(at Index: Int) {
        arrayOfNewSelectedSubActivity.remove(at: Index)
    }
    func removeDeletedSubActivityIds(at Index: Int) {
        arrayOfDeletedSubActivityIds.remove(at: Index)
    }
    
    func getIsDataLoad() -> Bool {
        return isDataLoad
    }
    func setIsDataLoad(value: Bool) {
        isDataLoad = value
    }
    
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrayOfActivity.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    //For setup profile time
    func convertSubActivityStructToString() -> String {
        
        var optionlist = [String]()
        
        for i in getSelectedSubActivity() {
            let dict : NSMutableDictionary = [apiParams.activityCategoryId : i.activityCategoryId,
                                              apiParams.activitySubCategoryId : i.activitySubCategoryId]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            
            optionlist.append(jsonstringstr!)
        }
        
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        
        return jsonstring!
    }
    
    //For edit profile time
    func convertNewSubActivityStructToString() -> String {
        
        var optionlist = [String]()
        
        for i in getNewSelectedSubActivity() {
            let dict : NSMutableDictionary = [apiParams.activityCategoryId : i.activityCategoryId,
                                              apiParams.activitySubCategoryId : i.activitySubCategoryId]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            
            optionlist.append(jsonstringstr!)
        }
        
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        
        return jsonstring!
    }
}
