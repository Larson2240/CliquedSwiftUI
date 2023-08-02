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
    @Published var arrayOfActivity = [ActivityCategoryClass]()
    @Published var arrayOfSelectedCategoryIds = [Int]()
    
    var arrayOfDeletedActivityIds = [Int]()
    var arrayOfSelectedPickActivity = [structPickActivityParams]()
    var arrayOfAllSelectedActivity = [structPickActivityParams]()
    var arrayOfNewPickActivity = [structPickActivityParams]()
    
    private let apiParams = ApiParams()
    
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
    
    func imageURL(for activity: ActivityCategoryClass, imageSize: CGSize) -> URL? {
        let strUrl = UrlActivityImage + (activity.image ?? "")
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        let baseTimbThumb = "\(URLBaseThumb)w=\(imageWidth * 3)&h=\(imageHeight * 3)&zc=1&src=\(strUrl)"
        
        return URL(string: baseTimbThumb)
    }
}

//MARK: getter/setter method
extension PickActivityViewModel {
    //For setup profile time
    func convertActivityStructToString() -> String {
        var optionlist = [String]()
        
        for i in arrayOfSelectedPickActivity {
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
        
        for i in arrayOfNewPickActivity {
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
