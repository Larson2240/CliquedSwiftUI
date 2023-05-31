//
//  PickActivityViewModel.swift
//  Cliqued
//
//  Created by C211 on 07/02/23.
//

import SwiftUI

struct structPickActivityParams {
    var activityCategoryId = ""
    var activitySubCategoryId = ""
}

final class PickActivityViewModel: ObservableObject {
    static var shared = PickActivityViewModel()
    
    @Published var arrayOfActivity = [ActivityCategoryClass]()
    @Published var arrayOfSelectedCategoryIds = [Int]()
    
    var arrayOfDeletedActivityIds = [Int]()
    private let apiParams = ApiParams()
    private var arrayOfSelectedPickActivity = [structPickActivityParams]()
    private var arrayOfAllSelectedActivity = [structPickActivityParams]()
    private var arrayOfNewPickActivity = [structPickActivityParams]()
    
    //MARK: Call Get Preferences Data API
    func callGetActivityDataAPI() {
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        arrayOfActivity.removeAll()
        
        UIApplication.shared.showLoader()
        
        RestApiManager.sharePreference.getResponseWithoutParams(webUrl: APIName.GetActivityCategory) { [weak self] response, error, message in
            guard let self = self else { return }
            
            UIApplication.shared.hideLoader()
            
            if error != nil && response == nil {
                UIApplication.shared.showAlertPopup(message: message ?? "")
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
                        }
                    }
                }
            }
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
    
    func getSelectedPickActivity() -> [structPickActivityParams] {
        arrayOfSelectedPickActivity
    }
    func getNewPickActivity() -> [structPickActivityParams] {
        arrayOfNewPickActivity
    }
    
    func getDeletedActivityIds() -> [Int] {
        arrayOfDeletedActivityIds
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
    func convertNewActivityStructToString() -> String {
        
        var optionlist = [String]()
        
        for i in getNewPickActivity() {
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
