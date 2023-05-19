//
//  ForgotPasswordViewModel.swift
//  Cliqued
//
//  Created by C211 on 10/02/23.
//

import UIKit

class ForgotPasswordViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<String> = Dynamic(String())
    
    //MARK: Variables
    private struct structForgotPassword {
        var email = ""
    }
    private var objForgotPassword = structForgotPassword()
    
    //MARK: Check Validation
    func checkValidation() -> Bool {
        var flag = false
        let isEmailAddressValid = isValidEmail(objForgotPassword.email)
        if objForgotPassword.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isMessage.value = Constants.validMsg_emailId
        } else if !isEmailAddressValid {
            self.isMessage.value = Constants.validMsg_invalidEmail
        } else {
            flag = true
        }
        return flag
    }
    
    //MARK: Call SignUp API
    func callForgotPasswordAPI() {
        if checkValidation() {
            let params : NSDictionary = [
                APIParams.email : objForgotPassword.email,
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async {
                    self.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.ForgotPwd, parameters: params) { response, error, message in
                    self.isLoaderShow.value = false
                    if(error != nil && response == nil) {
                        self.isMessage.value = message ?? ""
                    } else {
                        let json = response as? NSDictionary
                        let status = json?[API_STATUS] as? Int
                        let message = json?[API_MESSAGE] as? String
                        
                        if status == SUCCESS {
                            self.isDataGet.value = message ?? ""
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
//MARK: Getters and Setters
extension ForgotPasswordViewModel {
    
    func getEmail() -> String {
        objForgotPassword.email
    }
    
    func setEmail(value: String) {
        objForgotPassword.email = value
    }
}
