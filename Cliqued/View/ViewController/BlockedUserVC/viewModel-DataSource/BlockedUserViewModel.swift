//
//  BlockedUserViewModel.swift
//  Cliqued
//
//  Created by C100-132 on 10/02/23.
//

import Foundation

class BlockedUserViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isMarkStatusDataGet: Dynamic<Bool> = Dynamic(false)
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variables
    private var isDataLoad: Bool = false
    private struct userBlockedUserListParams {
        var user_id = ""
        var counter_user_id = ""
        var block_type = "0"
        var is_block = ""
    }
    private var structUserBlockedUserListValue = userBlockedUserListParams()
    private var offset = "0"
    private var isRefresh: Bool = false
    var arrBlockedUser = [BlockedUserClass]()
    var userIndex = -1
    
    //MARK: Check Validation
    func checkValidation() -> Bool {
        var flag = false
        
         if getUserId().isEmpty {
            self.isMessage.value = Constants_Message.user_id_validation
        } else if getCounterUserId().isEmpty {
            self.isMessage.value = Constants_Message.counter_user_id_validation
        } else {
            flag = true
        }
        return flag
    }
    
    //MARK: Call API
    func callUserListAPI() {
               
            let params: NSDictionary = [
                APIParams.userID : self.getUserId(),
                APIParams.offset: self.getOffset()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async {
                    if(Int(self.offset) == 0) {
                        self.arrBlockedUser.removeAll()
                    }
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetBlockedUserList, parameters: params) { response, error, message in
                    self.setIsDataLoad(value: true)
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                                                                  
                        if status == SUCCESS {
                            
                            if let userArray = json?["blocked_user_list"] as? NSArray {
                                if userArray.count > 0 {
                                    for userInfo in userArray {
                                        let dicUser = userInfo as! NSDictionary
                                        let decoder = JSONDecoder()
                                        do {
                                            let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                            let objUser = try decoder.decode(BlockedUserClass.self, from: jsonData)
                                            self.arrBlockedUser.append(objUser)
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            }
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
    
    func callMarkUserStatusAPI() {
        
        if checkValidation() {
            let params: NSDictionary = [
                APIParams.counterUserId : self.getCounterUserId(),
                APIParams.userID : self.getUserId(),
                APIParams.blockType : self.getBlockType(),
                APIParams.isBlock : self.getIsBlock()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async {
                    self.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.MarkUserAsBlock, parameters: params) { response, error, message in
                    self.isLoaderShow.value = false
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                        
                        if status == SUCCESS {
                            self.isMarkStatusDataGet.value = true
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

//MARK: Getter-Setter Method
extension BlockedUserViewModel {
    
    //Get methods
    func getUserId() -> String {
        structUserBlockedUserListValue.user_id
    }
    
    func getCounterUserId() -> String {
        structUserBlockedUserListValue.counter_user_id
    }
    
    func getBlockType() -> String {
        structUserBlockedUserListValue.block_type
    }
    
    func getIsBlock() -> String {
        structUserBlockedUserListValue.is_block
    }
        
    func getOffset() -> String {
        offset
    }
    
    func getIsRefresh() -> Bool {
        return isRefresh
    }
    
    func getUserIndex() -> Int {
        userIndex
    }
    
    //Set methods
    func setUserId(value: String) {
        structUserBlockedUserListValue.user_id = value
    }
    
    func setCounterUserId(value: String) {
        structUserBlockedUserListValue.counter_user_id = value
    }
    
    func setBlockType(value: String) {
        structUserBlockedUserListValue.block_type = value
    }
    
    func setIsBlock(value: String) {
        structUserBlockedUserListValue.is_block = value
    }
    
    func setOffset(value: String) {
        offset = value
    }
    
    func setIsRefresh(value:Bool) {
        isRefresh = value
    }
    
    func setUserIndex(value: Int) {
        userIndex = value
    }
    
    func getIsDataLoad() -> Bool {
        return isDataLoad
    }
    func setIsDataLoad(value: Bool) {
        isDataLoad = value
    }
    
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrBlockedUser.count == 0 {
            return true
        } else {
            return false
        }
    }
}
