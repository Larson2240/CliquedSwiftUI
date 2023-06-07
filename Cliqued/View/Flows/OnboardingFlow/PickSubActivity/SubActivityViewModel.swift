//
//  SubActivityViewModel.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 28.05.2023.
//

import Combine

struct structPickSubActivityParams {
    var activityCategoryId = ""
    var activitySubCategoryId = ""
}

final class PickSubActivityViewModel: ObservableObject {
    @Published var arrayOfActivity = [ActivityCategoryClass]()
    @Published var arrayOfActivityAllData = [ActivityCategoryClass]()
    @Published var arrayOfSelectedSubActivity = [structPickSubActivityParams]()
    
    private var arrayOfNewSelectedSubActivity = [structPickSubActivityParams]()
    private var arrayOfAllSelectedSubActivity = [structPickSubActivityParams]()
    private var arrayOfDeletedSubActivityIds = [Int]()
    private let apiParams = ApiParams()
    
    //MARK: Call Get Preferences Data API
    func callGetActivityDataAPI(categoryIDs: String) {
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.activityCategoryId : categoryIDs
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetActivityCategory, parameters: params) { [weak self] response, error, message in
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
                            
                            self.setActivityAllData(value: self.arrayOfActivity)
                        }
                    }
                }
            }
        }
    }
}

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
