//
//  PickActivityViewModel.swift
//  Cliqued
//
//  Created by C211 on 07/02/23.
//

import UIKit

struct structPickActivityParams {
    var activityCategoryId = ""
    var activitySubCategoryId = ""
}

class PickActivityViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isActivityDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variable
    private var isDataLoad: Bool = false
    private var isRefresh: Bool = false
    var arrayOfActivity = [ActivityCategoryClass]()
    private var arrayOfSelectedPickActivity = [structPickActivityParams]()
    private var arrayOfAllSelectedActivity = [structPickActivityParams]()
    private var arrayOfNewPickActivity = [structPickActivityParams]()
    var arrayOfDeletedActivityIds = [Int]()
    var arrayOfSelectedCategoryIds = [Int]()
    
    //MARK: Call Get Preferences Data API
    func callGetActivityDataAPI() {
        
        if(Connectivity.isConnectedToInternet()) {
            DispatchQueue.main.async {
                self.arrayOfActivity.removeAll()
            }
            RestApiManager.sharePreference.getResponseWithoutParams(webUrl: APIName.GetActivityCategory) { response, error, message in
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
extension PickActivityViewModel {
    
    func getNumberOfActivity() -> Int {
        arrayOfActivity.count
    }
    
    func getActivityData(at index: Int) -> ActivityCategoryClass {
        arrayOfActivity[index]
    }
    
    func getIsDataLoad() -> Bool {
        return isDataLoad
    }
    
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrayOfActivity.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    func getSelectedPickActivity() -> [structPickActivityParams] {
        arrayOfSelectedPickActivity
    }
    func getNewPickActivity() -> [structPickActivityParams] {
        arrayOfNewPickActivity
    }
    
    func getDeletedActivityIds() -> [Int] {
        arrayOfDeletedActivityIds
    }
    
    func setIsDataLoad(value: Bool) {
        isDataLoad = value
    }
    func setPickActivity(value: structPickActivityParams) {
        arrayOfSelectedPickActivity.append(value)
    }
    func setNewPickActivity(value: structPickActivityParams) {
        arrayOfNewPickActivity.append(value)
    }
    func setActivity(value: structPickActivityParams) {
        arrayOfNewPickActivity.append(value)
    }
    func setAllSelectedActivity(value: structPickActivityParams) {
        arrayOfAllSelectedActivity.append(value)
    }
    func removeAllSelectedActivity() {
        arrayOfAllSelectedActivity.removeAll()
    }
    func getAllSelectedActivity() -> [structPickActivityParams] {
        arrayOfAllSelectedActivity
    }
    
    func removePickActivity(at Index: Int) {
        arrayOfSelectedPickActivity.remove(at: Index)
    }
    func removeNewPickActivity(at Index: Int) {
        arrayOfNewPickActivity.remove(at: Index)
    }
    
    func setDeletedActivityIds(value: Int) {
        arrayOfDeletedActivityIds.append(value)
    }
    func removeDeletedActivityIds(at Index: Int) {
        arrayOfDeletedActivityIds.remove(at: Index)
    }
    
    func removeAllSelectedArray() {
        arrayOfSelectedPickActivity.removeAll()
    }
    func removeAllNewSelectedArray() {
        arrayOfNewPickActivity.removeAll()
    }
    
    func getIsRefresh() -> Bool {
        return isRefresh
    }
    
    func setIsRefresh(value:Bool) {
        isRefresh = value
    }
    
    
    func setSelectedCategoryId(value: Int) {
        arrayOfSelectedCategoryIds.append(value)
    }
    func removeSelectedCategoryId(at Index: Int) {
        arrayOfSelectedCategoryIds.remove(at: Index)
    }
    func removeAllSelectedCategoryId() {
        arrayOfSelectedCategoryIds.removeAll()
    }
    func getSelectedCategoryId() -> [Int] {
        arrayOfSelectedCategoryIds
    }
    
    
    
    //For setup profile time
    func convertActivityStructToString() -> String {
        
        var optionlist = [String]()
        
        for i in getSelectedPickActivity() {
            let dict : NSMutableDictionary = [APIParams.activityCategoryId : i.activityCategoryId,
                                              APIParams.activitySubCategoryId : i.activitySubCategoryId]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            
            optionlist.append(jsonstringstr!)
        }
        
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        
        return jsonstring!
    }
    
    //For edit profile time
    func convertNewActivityStructToString() -> String {
        
        var optionlist = [String]()
        
        for i in getNewPickActivity() {
            let dict : NSMutableDictionary = [APIParams.activityCategoryId : i.activityCategoryId,
                                              APIParams.activitySubCategoryId : i.activitySubCategoryId]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            
            optionlist.append(jsonstringstr!)
        }
        
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        
        return jsonstring!
    }
}
