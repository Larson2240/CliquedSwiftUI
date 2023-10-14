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
    
    private let apiParams = ApiParams()
    private let activityWebService = ActivityWebService()
    
    //MARK: Variables
    struct addActivityParams {
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
    var structAddActivityValue = addActivityParams()
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
        guard checkValidation() else { return }
        
        guard Connectivity.isConnectedToInternet() else {
            self.isMessage.value = Constants.alert_InternetConnectivity
            return
        }
        
        let params: [String: Any] = [
            "activityCategories": ["/api/activity_categories/\(structAddActivityValue.activity_id)"],
            "title": getTitle(),
            "description": getDescription(),
            "activityDate": getActivityDate(),
            "address": structAddActivityValue.activity_address.first?.address ?? "",
            "latitude": Double(structAddActivityValue.activity_address.first?.latitude ?? "0") ?? 0,
            "longitude": Double(structAddActivityValue.activity_address.first?.longitude ?? "0") ?? 0,
            "city": structAddActivityValue.activity_address.first?.city ?? "",
            "state": structAddActivityValue.activity_address.first?.state ?? "",
            "country": structAddActivityValue.activity_address.first?.country ?? "",
            "pincode": structAddActivityValue.activity_address.first?.pincode ?? ""
        ]
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoaderShow.value = true
        }
        
        activityWebService.createActivity(parameters: params) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let activity):
                guard let image = structAddActivityValue.activity_media.first else {
                    self.isLoaderShow.value = false
                    self.isDataGet.value = true
                    return
                }
                
                self.activityWebService.updateActivityMedia(activityID: String(activity.id),
                                                            image: image) { result in
                    self.isLoaderShow.value = false
                    self.isDataGet.value = true
                }
            case .failure(let error):
                if let error = error as? ApiError, let message = error.errorDescription {
                    UIApplication.shared.showAlertPopup(message: message)
                }
                
                self.isLoaderShow.value = false
            }
        }
    }
    
    func callEditActivityAPI() {
        guard checkEditValidation() else { return }
        
        guard Connectivity.isConnectedToInternet() else {
            self.isMessage.value = Constants.alert_InternetConnectivity
            return
        }
        
        let params: [String: Any] = [
              "activityCategories": ["/api/activity_categories/\(structAddActivityValue.activity_id)"],
              "title": getTitle(),
              "description": getDescription(),
              "activityDate": getActivityDate(),
              "address": structAddActivityValue.activity_address.first?.address ?? "",
              "latitude": Double(structAddActivityValue.activity_address.first?.latitude ?? "0") ?? 0,
              "longitude": Double(structAddActivityValue.activity_address.first?.longitude ?? "0") ?? 0,
              "city": structAddActivityValue.activity_address.first?.city ?? "",
              "state": structAddActivityValue.activity_address.first?.state ?? "",
              "country": structAddActivityValue.activity_address.first?.country ?? "",
              "pincode": structAddActivityValue.activity_address.first?.pincode ?? ""
        ]
        
        guard let activityID = objActivityDetails?.id else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoaderShow.value = true
        }
        
        activityWebService.updateActivity(activityID: String(activityID), parameters: params) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let activity):
                guard let image = structAddActivityValue.activity_media.first else {
                    self.isLoaderShow.value = false
                    self.isDataGet.value = true
                    return
                }
                
                self.activityWebService.updateActivityMedia(activityID: String(activity.id),
                                                            image: image) { result in
                    self.isLoaderShow.value = false
                    self.isDataGet.value = true
                }
            case .failure(let error):
                if let error = error as? ApiError, let message = error.errorDescription {
                    UIApplication.shared.showAlertPopup(message: message)
                }
                
                self.isLoaderShow.value = false
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
            
            let dict : NSMutableDictionary = [apiParams.address : i.address ,
                                              apiParams.latitude : i.latitude ,
                                              apiParams.longitude : i.longitude ,
                                              apiParams.city : i.city,
                                              apiParams.state : i.state,
                                              apiParams.country : i.country,
                                              apiParams.pincode : i.pincode,
                                              apiParams.addressId : i.address_id
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
            let dict : NSMutableDictionary = [apiParams.activityCategoryId : i.activity_category_id ,
                                              apiParams.activitySubCategoryId : i.activity_sub_category_id
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
