//
//  MatchScreenViewModel.swift
//  Cliqued
//
//  Created by C211 on 02/05/23.
//

import UIKit

class MatchScreenViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    private let apiParams = ApiParams()
    
    //MARK: Variable
    private var isDataLoad: Bool = false
    private struct setFollowStatusParams {
        var counterUserId = ""
        var isActivity = ""
    }
    private var structFollowStatusParamValue = setFollowStatusParams()
    
    //MARK: Call Like Dislike profile API
    func callSendPushNotificationAPI() {
        
        let params: NSDictionary = [
//            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.counterUserId : self.getCounterUserId(),
            apiParams.isActivity : self.getIsActivity()
        ]
        
        if(Connectivity.isConnectedToInternet()) {
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.SendPushNotificationToMatchedUser, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
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
//MARK: getter/setter method
extension MatchScreenViewModel {
    
    func setCounterUserId(value:String) {
        structFollowStatusParamValue.counterUserId = value
    }
    func setIsActivity(value:String) {
        structFollowStatusParamValue.isActivity = value
    }
    
    func getCounterUserId() -> String {
        return structFollowStatusParamValue.counterUserId
    }
    func getIsActivity() -> String {
        return structFollowStatusParamValue.isActivity
    }
}
