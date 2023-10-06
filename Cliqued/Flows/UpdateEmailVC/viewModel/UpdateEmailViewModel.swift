//
//  UpdateEmailViewModel.swift
//  Cliqued
//
//  Created by C100-132 on 16/02/23.
//

import Foundation

class UpdateEmailViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    var isUserDataGet: Dynamic<Bool> = Dynamic(false)
    
    private let apiParams = ApiParams()
    
    //MARK: Variables
    private struct updateEmailParams {
        var userId = ""
        var emailId = ""
        var newEmailId = ""
        var otpCode = ""
    }
    
    private var structUpdateEmailValue = updateEmailParams()
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User){
//        Constants.saveUser(user: user)
    }
    
    //MARK: Check Validation
    func checkOTPValidation() -> Bool {
        var flag = false
        let isEmailAddressValid = isValidEmail(getNewEmailId())
        
//        if getUserId().isEmpty {
//            self.isMessage.value = Constants_Message.user_id_validation
//        } else if getEmailId().isEmpty {
//            self.isMessage.value = Constants_Message.validMsg_old_emailId
//        } else if getNewEmailId().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//            self.isMessage.value = Constants.validMsg_emailId
//        } else if getNewEmailId() == Constants.loggedInUser?.connectedAccount![0].emailId {
//            self.isMessage.value = Constants.validMsg_alredyHaveEmailId
//        } else if !isEmailAddressValid {
//            self.isMessage.value = Constants.validMsg_invalidEmail
//        } else {
//            flag = true
//        }
        return flag
    }
    
    func checkUpdateValidation() -> Bool {
        var flag = false
        let isEmailAddressValid = isValidEmail(getNewEmailId())
        
        if getUserId().isEmpty {
            self.isMessage.value = Constants_Message.user_id_validation
        } else if getEmailId().isEmpty {
            self.isMessage.value = Constants_Message.validMsg_old_emailId
        } else if getNewEmailId().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isMessage.value = Constants.validMsg_emailId
        } else if !isEmailAddressValid {
            self.isMessage.value = Constants.validMsg_invalidEmail
        } else if getOTPCode().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isMessage.value = Constants_Message.validMsg_otp_emailId
        } else {
            flag = true
        }
        return flag
    }
    
    //MARK: Call API
    func callSendOTPAPI() {
        
        if checkOTPValidation() {
            let params: NSDictionary = [
                apiParams.email : self.getEmailId(),
                apiParams.userID : self.getUserId(),
                apiParams.newEmail : self.getNewEmailId()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async { [weak self] in
                    self?.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.SentOTPForEmailID, parameters: params) { [weak self] response, error, message in
                    guard let self = self else { return }
                    
                    self.isLoaderShow.value = false
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                                                
                        if status == SUCCESS {
                            self.isMessage.value = message ?? ""
                            self.isDataGet.value = true
                        }  else {
                            self.isMessage.value = message ?? ""
                        }
                    }
                }
            } else {
                self.isMessage.value = Constants.alert_InternetConnectivity
            }
        }
    }
    
    func callVerifyOTPAndUpdateAPI() {
        
        if checkUpdateValidation() {
            let params: NSDictionary = [
                apiParams.email : self.getEmailId(),
                apiParams.userID : self.getUserId(),
                apiParams.newEmail : self.getNewEmailId(),
                apiParams.optCode : self.getOTPCode()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async { [weak self] in
                    self?.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.VerifyOTPForEmailID, parameters: params) { [weak self] response, error, message in
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
                                        self.saveUserInfoAndProceed(user: objUser)
                                        UserDefaults.standard.set(true, forKey: UserDefaultKey().isLoggedIn)
                                        self.isUserDataGet.value = true
                                    } catch {
                                        print(error.localizedDescription)
                                    }                                    
                                } else {
                                    self.isDataGet.value = true
                                }
                            }
                        }  else {
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
extension UpdateEmailViewModel {
    
    //Get methods
    func getUserId() -> String {
        structUpdateEmailValue.userId
    }
    
    func getEmailId() -> String {
        structUpdateEmailValue.emailId
    }
    
    func getNewEmailId() -> String {
        structUpdateEmailValue.newEmailId
    }
    
    func getOTPCode() -> String {
        structUpdateEmailValue.otpCode
    }
    
    //Set methods
    func setUserId(value: String) {
        structUpdateEmailValue.userId = value
    }
    
    func setEmailId(value: String) {
        structUpdateEmailValue.emailId = value
    }
    
    func setNewEmailId(value: String) {
        structUpdateEmailValue.newEmailId = value
    }
    
    func setOTPCode(value: String) {
        structUpdateEmailValue.otpCode = value
    }
}
