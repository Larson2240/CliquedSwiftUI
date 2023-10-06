//
//  SubscriptionPlanViewModel.swift
//  Cliqued
//
//  Created by C211 on 20/02/23.
//

import UIKit

class SubscriptionPlanViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isDataPurchased: Dynamic<Bool> = Dynamic(false)
    
    var arrayOfPlan = [SubscriptionPlanClass]()
    var objPlan: SubscriptionPlanClass!
    private var isDataLoad: Bool = false
    
    //MARK: Variables
    private struct subscriptionPlanParams {
        var subscription_id = ""
        var transaction_id = ""
        var transaction_date = ""
        var amount = ""
        var start_date = ""
        var end_date = ""
        var is_active = ""
    }
    
    private var structsubscriptionPlanParamsValue = subscriptionPlanParams()
    private let apiParams = ApiParams()
    
    func callGetSubscriptionPlanAPI() {
        
        guard Connectivity.isConnectedToInternet() else {
            isMessage.value = Constants.alert_InternetConnectivity
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoaderShow.value = true
        }
        
        RestApiManager.sharePreference.getResponseWithoutParams(webUrl: APIName.GetSubscriptionPlanList) { [weak self] response, error, message in
            guard let self = self else { return }
            
            self.isLoaderShow.value = false
            self.setIsDataLoad(value: true)
            if error != nil && response == nil {
                self.isMessage.value = message ?? ""
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                let msg = json?[API_MESSAGE] as? String
                
                if status == SUCCESS {
                    if let planArray = json?["subscription_list"] as? NSArray {
                        if planArray.count > 0 {
                            for planInfo in planArray {
                                let dicPlan = planInfo as! NSDictionary
                                let decoder = JSONDecoder()
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject:dicPlan)
                                    let planData = try decoder.decode(SubscriptionPlanClass.self, from: jsonData)
                                    self.arrayOfPlan.append(planData)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            self.isDataGet.value = true
                        } else {
                            self.isDataGet.value = true
                        }
                    }
                } else {
                    self.isMessage.value = msg ?? ""
                }
            }
        }
    }
    
    //MARK: Social Login API
    func callAddSubscriptionDetailsAPI() {
        let params: NSDictionary = [
//            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.subscriptionId : self.getSubscriptionId(),
            apiParams.transactionId : self.getTransactionId(),
            apiParams.amount : self.getAmount(),
            apiParams.transactionStartDate : self.getPlanStartDate(),
            apiParams.transactionEndDate : self.getPlanEndDate(),
            apiParams.isActive : self.getIsActive()
        ]
        
        guard Connectivity.isConnectedToInternet() else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoaderShow.value = true
        }
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.addUserSubscriptionDetails, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            self.isLoaderShow.value = false
            if error != nil && response == nil {
                self.isMessage.value = message ?? ""
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                let message = json?[API_MESSAGE] as? String
                
                if status == SUCCESS {
                    self.isDataPurchased.value = true
                } else {
                    self.isMessage.value = message ?? ""
                }
            }
        }
    }
}

//MARK: getter/setter method
extension SubscriptionPlanViewModel {
    
    func getNumberOfPlan() -> Int {
        return arrayOfPlan.count
    }
    func getAllPlans() -> [SubscriptionPlanClass] {
        return arrayOfPlan
    }
    
    func getPlanData() -> SubscriptionPlanClass {
        objPlan
    }
    func setPlanData(value: SubscriptionPlanClass) {
        objPlan = value
    }
    
    func getIsDataLoad() -> Bool {
        return isDataLoad
    }
    func setIsDataLoad(value: Bool) {
        isDataLoad = value
    }
    
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrayOfPlan.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    
    func getSubscriptionId() -> String {
        return structsubscriptionPlanParamsValue.subscription_id
    }
    func getTransactionId() -> String {
        return structsubscriptionPlanParamsValue.transaction_id
    }
    func getAmount() -> String {
        return structsubscriptionPlanParamsValue.amount
    }
    func getTransactionDate() -> String {
        return structsubscriptionPlanParamsValue.transaction_date
    }
    func getPlanStartDate() -> String {
        return structsubscriptionPlanParamsValue.start_date
    }
    func getPlanEndDate() -> String {
        return structsubscriptionPlanParamsValue.end_date
    }
    func getIsActive() -> String {
        return structsubscriptionPlanParamsValue.is_active
    }
    
    func setSubscriptionId(value: String) {
        structsubscriptionPlanParamsValue.subscription_id = value
    }
    func setTransactionId(value: String) {
        structsubscriptionPlanParamsValue.transaction_id = value
    }
    func setAmount(value: String) {
        structsubscriptionPlanParamsValue.amount = value
    }
    func setTransactionDate(value: String) {
        structsubscriptionPlanParamsValue.transaction_date = value
    }
    func setPlanStartDate(value: String) {
        structsubscriptionPlanParamsValue.start_date = value
    }
    func setPlanEndDate(value: String) {
        structsubscriptionPlanParamsValue.end_date = value
    }
    func setIsActive(value: String) {
        structsubscriptionPlanParamsValue.is_active = value
    }
    
}
