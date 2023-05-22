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
    private let apiParams = ApiParams()
    
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
                apiParams.email : objForgotPassword.email,
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async { [weak self] in
                    self?.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.ForgotPwd, parameters: params) { [weak self] response, error, message in
                    guard let self = self else { return }
                    
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
