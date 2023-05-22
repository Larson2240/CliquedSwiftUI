//
//  ChatViewModel.swift
//  Cliqued
//
//  Created by C100-132 on 28/01/23.
//

import Foundation

class ChatViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isUserDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variables
    private var isDataLoad: Bool = false
    private var isConversationDataLoad: Bool = false
    private struct chatListParams {
        var user_id = ""
        var is_premium = ""
        var sender_id = ""
    }
    private var structChatListValue = chatListParams()
    var arrUserMatchesList = [UserLikesMatchesClass]()
    
    var arrSingleLikesList = [UserLikesMatchesClass]()
    var arrMatchesList = [UserLikesMatchesClass]()
    var arrConversation = [CDConversation]()
    var arrayOfMainUserList = [User]()
    private let apiParams = ApiParams()
    
    //MARK: Call API
    
    func callGetUserDetailsAPI(user_id: Int) {
        
        let params: NSDictionary = [
            apiParams.userID : user_id
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.isLoaderShow.value = true
                self.arrayOfMainUserList.removeAll()
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUserDetails, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.isLoaderShow.value = false
                if(error != nil && response == nil) {
                    self.isMessage.value = message ?? ""
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let message = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        
                        if let userArray = json?["user"] as? NSArray {
                            if userArray.count > 0 {
                                let dicUser = userArray[0] as! NSDictionary
                                let decoder = JSONDecoder()
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                    let objUser = try decoder.decode(User.self, from: jsonData)
                                    self.arrayOfMainUserList.append(objUser)
                                    self.isUserDataGet.value = true
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    } else {
                        self.isMessage.value = message ?? ""
                    }
                }
            }
        } else {
            self.isMessage.value = Constants.alert_InternetConnectivity
        }
    }
    
    func callUserLikesListAPI() {
               
            let params: NSDictionary = [
                apiParams.userID : self.getUserId()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async { [weak self] in
                    self?.arrUserMatchesList.removeAll()
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.GetUserLikesList, parameters: params) { [weak self] response, error, message in
                    guard let self = self else { return }
                    
                    self.setIsDataLoad(value: true)
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                        
                        self.setIsPremium(value: json?["is_premium"] as? String ?? "")
                                            
                        if status == SUCCESS {
                           
                            if let userArray = json?["Likes_List"] as? NSArray {
                                if userArray.count > 0 {
                                    for userInfo in userArray {
                                        let dicUser = userInfo as! NSDictionary
                                        let decoder = JSONDecoder()
                                        do {
                                            let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                            let objUser = try decoder.decode(UserLikesMatchesClass.self, from: jsonData)
                                            self.arrUserMatchesList.append(objUser)
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
extension ChatViewModel {
    
    //Get methods
    func getUserId() -> String {
        structChatListValue.user_id
    }
    
    func getIsPremium() -> String {
        structChatListValue.is_premium
    }
    
    func getSenderId() -> String {
        structChatListValue.sender_id
    }
   
    //Set methods
    func setUserId(value: String) {
        structChatListValue.user_id = value
    }
    
    func setIsPremium(value: String) {
        structChatListValue.is_premium = value
    }
    
    func setSenderId(value: String) {
        structChatListValue.sender_id = value
    }
    
    func getIsDataLoad() -> Bool {
        return isDataLoad
    }
    func setIsDataLoad(value: Bool) {
        isDataLoad = value
    }
    
    func getIsConversationDataLoad() -> Bool {
        return isConversationDataLoad
    }
    func setIsConversationDataLoad(value: Bool) {
        isConversationDataLoad = value
    }
    
    func isCheckEmptyData() -> Bool {
        if isDataLoad && arrUserMatchesList.count == 0 {
            return true
        } else {
            return false
        }
    }
}
