//
//  ChangePasswordViewModel.swift
//  Cliqued
//
//  Created by C100-132 on 17/02/23.
//

import Foundation

class ChangePasswordViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variables
    private struct changePasswordParams {
        var userId = ""
        var oldPassword = ""
        var newPassword = ""
        var confirmPassword = ""
    }
    
    private var structChangePasswordValue = changePasswordParams()
    
    //MARK: Check Validation
    func checkUpdateValidation() -> Bool {
        var flag = false
        let isPasswordValid = isPasswordHasNumberAndCharacter(password: getNewPassword())
        
        if getUserId().isEmpty {
            self.isMessage.value = Constants_Message.user_id_validation
        } else if getOldPassword().isEmpty {
            self.isMessage.value = Constants_Message.validMsg_old_password
        } else if getNewPassword().isEmpty {
            self.isMessage.value = Constants_Message.validMsg_new_password
        } else if !isPasswordValid {
            self.isMessage.value = Constants.validMsg_invalidPassword
        } else if getConfirmPassword().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isMessage.value = Constants.validMsg_repeatPassword
        } else if getNewPassword() != getConfirmPassword() {
            self.isMessage.value = Constants.validMsg_passwordNotMatche
        } else {
            flag = true
        }
        return flag
    }
    
    //MARK: Call API
    func callChangePasswordAPI() {
        
        if checkUpdateValidation() {
            let params: NSDictionary = [
                APIParams.oldPassword : self.getOldPassword(),
                APIParams.newPassword : self.getNewPassword(),
                APIParams.userID : self.getUserId()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async {
                    self.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.ChangePassword, parameters: params) { response, error, message in
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
}

//MARK: Getter-Setter Method
extension ChangePasswordViewModel {
    
    //Get methods
    func getUserId() -> String {
        structChangePasswordValue.userId
    }
    
    func getOldPassword() -> String {
        structChangePasswordValue.oldPassword
    }
    
    func getNewPassword() -> String {
        structChangePasswordValue.newPassword
    }
    
    func getConfirmPassword() -> String {
        structChangePasswordValue.confirmPassword
    }
    
    //Set methods
    func setUserId(value: String) {
        structChangePasswordValue.userId = value
    }
    
    func setOldPassword(value: String) {
        structChangePasswordValue.oldPassword = value
    }
    
    func setNewPassword(value: String) {
        structChangePasswordValue.newPassword = value
    }
    
    func setConfirmPassword(value: String) {
        structChangePasswordValue.confirmPassword = value
    }
}
