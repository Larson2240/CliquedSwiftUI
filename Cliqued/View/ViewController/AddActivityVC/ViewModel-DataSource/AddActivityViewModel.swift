//
//  AddActivityViewModel.swift
//  Cliqued
//
//  Created by C211 on 20/01/23.
//

import UIKit

class AddActivityViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variables
    private struct addActivityParams {
        var user_id = ""
        var title = ""
        var description = ""
        var date = ""
        var activity_media = [UIImage]()
        var activity_address = [activityAddressStruct]()
        var activity_sub_category = [activitySubCategoryStruct]()
        var activity_category_title = ""
        var activity_id = ""
    }
    private var structAddActivityValue = addActivityParams()
    var objActivityDetails : UserActivityClass?
    var isSelectedDateNotValid: Bool = false
    
    //MARK: Check Validation
    func checkValidation() -> Bool {
        var flag = false
        
        if getActivityAllSubCategory().count == 0 || getActivityCategoryTitle().isEmpty {
            self.isMessage.value = Constants_Message.activity_category_validation
        } else if getTitle().isEmpty {
            self.isMessage.value = Constants_Message.activity_title_validation
        } else if getActivityAllMedia().count == 0 {
            self.isMessage.value = Constants_Message.activity_media_validation
        } else if getActivityDate().isEmpty {
            self.isMessage.value = Constants_Message.activity_date_validation
        } else if getIsSelectedDateNotValid() {
            self.isMessage.value = Constants_Message.activity_wrongSelectDate_validation
        } else if getDescription().isEmpty {
            self.isMessage.value = Constants_Message.activity_description_validation
        } else if getAllActivityAddress().count == 0 {
            self.isMessage.value = Constants_Message.activity_address_validation
        } else {
            flag = true
        }
        return flag
    }
    
    func checkEditValidation() -> Bool {
        var flag = false
        
        if getActivityId().isEmpty {
            self.isMessage.value = Constants_Message.activity_id_validation
        } else if getActivityAllSubCategory().count == 0 || getActivityCategoryTitle().isEmpty {
            self.isMessage.value = Constants_Message.activity_category_validation
        } else if getTitle().isEmpty {
            self.isMessage.value = Constants_Message.activity_title_validation
        } else if getActivityAllMedia().count == 0 {
            self.isMessage.value = Constants_Message.activity_media_validation
        } else if getActivityDate().isEmpty {
            self.isMessage.value = Constants_Message.activity_date_validation
        } else if getIsSelectedDateNotValid() {
            self.isMessage.value = Constants_Message.activity_wrongSelectDate_validation
        } else if getDescription().isEmpty {
            self.isMessage.value = Constants_Message.activity_description_validation
        } else if getAllActivityAddress().count == 0 {
            self.isMessage.value = Constants_Message.activity_address_validation
        } else {
            flag = true
        }
        return flag
    }
    
    
    //MARK: Call Activity API
    func callCreateActivityAPI() {
               
        if checkValidation() {
            let params: NSDictionary = [
                APIParams.userID : self.getUserId(),
                APIParams.title : self.getTitle(),
                APIParams.description : self.getDescription(),
                APIParams.date : self.getActivityDate(),
                APIParams.activity_address : self.convertAddressStructToString(),
                APIParams.activity_sub_category : self.convertSubCategoryStructToString(),
                APIParams.activity_media : self.getActivityAllMedia(),
                APIParams.thumbnail : self.getActivityAllMedia()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async {
                    self.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.AddUserActivity, parameters: params) { response, error, message in
                    self.isLoaderShow.value = false
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                                            
                        if status == SUCCESS {
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
    
    func callEditActivityAPI() {
               
        if checkEditValidation() {
            let params: NSDictionary = [
                APIParams.userID : self.getUserId(),
                APIParams.title : self.getTitle(),
                APIParams.description : self.getDescription(),
                APIParams.date : self.getActivityDate(),
                APIParams.activity_address : self.convertAddressStructToString(),
                APIParams.activity_sub_category : self.convertSubCategoryStructToString(),
                APIParams.activity_media : self.getActivityAllMedia(),
                APIParams.thumbnail : self.getActivityAllMedia(),
                APIParams.activityId : self.getActivityId()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async {
                    self.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.EditActivity, parameters: params) { response, error, message in
                    self.isLoaderShow.value = false
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                                            
                        if status == SUCCESS {
                            if let userActivity = json?["user_activity"] as? NSArray {
                                if userActivity.count > 0 {
                                    let dicActivity = userActivity[0] as! NSDictionary
                                    let decoder = JSONDecoder()
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject:dicActivity)
                                        let objActivityData = try decoder.decode(UserActivityClass.self, from: jsonData)
                                        self.objActivityDetails = objActivityData
//                                        self.setObjActivityDetails(value: objActivityData)
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                } else {
                                    self.isDataGet.value = true
                                }
                            }
                            self.isDataGet.value = true
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
}

extension AddActivityViewModel {
    
    //Get methods
    func getUserId() -> String {
        structAddActivityValue.user_id
    }
    
    func getTitle() -> String {
        structAddActivityValue.title
    }
    
    func getActivityCategoryTitle() -> String {
        structAddActivityValue.activity_category_title
    }
    
    func getDescription() -> String {
        structAddActivityValue.description
    }
    
    func getActivityDate() -> String {
        structAddActivityValue.date
    }
    
    func getActivityId() -> String {
        structAddActivityValue.activity_id
    }
    
    func getActivityAllMedia() -> [UIImage] {
        structAddActivityValue.activity_media
    }
    
    func getAllActivityAddress() -> [activityAddressStruct] {
        structAddActivityValue.activity_address
    }
    
    func getActivityAllSubCategory() -> [activitySubCategoryStruct] {
        structAddActivityValue.activity_sub_category
    }
    
    func getActivityMedia(at: Int) -> UIImage? {
        structAddActivityValue.activity_media[at]
    }
    
    func getActivityMedia() -> Int {
        return structAddActivityValue.activity_media.count
    }
    
    func getActivityAddress(at: Int) -> activityAddressStruct {
        structAddActivityValue.activity_address[at]
    }
    
    func getActivityAddress() -> Int {
        return structAddActivityValue.activity_address.count
    }
    
    func getActivitySubCategory(at: Int) -> activitySubCategoryStruct {
        structAddActivityValue.activity_sub_category[at]
    }
    
    func getActivitySubCategory() -> Int {
        return structAddActivityValue.activity_sub_category.count
    }
    
    func getIsSelectedDateNotValid() -> Bool {
        return isSelectedDateNotValid
    }

    
    // remove method
    func removeActivityAllMedia() {
        structAddActivityValue.activity_media.removeAll()
    }
    
    func removeActivityMedia(at: Int) {
        structAddActivityValue.activity_media.remove(at: at)
    }
    
    func removeActivityAddress() {
        structAddActivityValue.activity_address.removeAll()
        
    }

    func removeActivityAllSubCategory() {
        structAddActivityValue.activity_sub_category.removeAll()
    }
    
    func removeActivitySubCategory(at: Int) {
        structAddActivityValue.activity_sub_category.remove(at: at)
    }
   
    //Set methods
    func setUserId(value: String) {
        structAddActivityValue.user_id = value
    }
    
    func setTitle(value: String) {
        structAddActivityValue.title = value
    }
    
    func setActivityCategoryTitle(value: String) {
        structAddActivityValue.activity_category_title = value
    }
    
    func setDescription(value: String) {
        structAddActivityValue.description = value
    }
    
    func setDate(value: String) {
        structAddActivityValue.date = value
    }
    
    func setActivityId(value: String) {
        structAddActivityValue.activity_id = value
    }
    
    func setActivityMedia(value: UIImage) {
        structAddActivityValue.activity_media.append(value)
    }
    
    func setActivityAddress(value: activityAddressStruct) {
        structAddActivityValue.activity_address.append(value)
    }
    
    func setActivitySubCategory(value: activitySubCategoryStruct) {
        structAddActivityValue.activity_sub_category.append(value)
    }
    
    func setIsSelectedDateNotValid(value: Bool) {
        isSelectedDateNotValid = value
    }
    
    func convertAddressStructToString() -> String {
        
        var optionlist = [String]()
        
        for i in getAllActivityAddress() {
//            let dict = structAddActivityValue.activity_address[i]
            
            let dict : NSMutableDictionary = [APIParams.address : i.address ,
                                              APIParams.latitude : i.latitude ,
                                              APIParams.longitude : i.longitude ,
                                              APIParams.city : i.city,
                                              APIParams.state : i.state,
                                              APIParams.country : i.country,
                                              APIParams.pincode : i.pincode,
                                              APIParams.addressId : i.address_id
            ]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            
            optionlist.append(jsonstringstr!)
        }
        
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        
        return jsonstring!
    }
    
    func convertSubCategoryStructToString() -> String {
        
        var optionlist = [String]()
        
        for i in getActivityAllSubCategory() {
            let dict : NSMutableDictionary = [APIParams.activityCategoryId : i.activity_category_id ,
                                              APIParams.activitySubCategoryId : i.activity_sub_category_id
            ]
            
            let dictdata : Data = try! JSONSerialization.data(withJSONObject: dict, options: [])
            let jsonstringstr = String(data: dictdata as Data, encoding: .utf8)
            
            optionlist.append(jsonstringstr!)
        }
        
        let tappingdata : Data = try! JSONSerialization.data(withJSONObject: optionlist, options: [])
        let jsonstring = String(data: tappingdata as Data, encoding: .utf8)
        
        return jsonstring!
    }
}
