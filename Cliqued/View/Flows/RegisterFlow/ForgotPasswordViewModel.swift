//
//  ForgotPasswordViewModel.swift
//  Cliqued
//
//  Created by C211 on 10/02/23.
//

import Combine

final class ForgotPasswordViewModel: ObservableObject {
    @Published var email = ""
    private let apiParams = ApiParams()
    
    var dismissAction: ((String) -> Void)?
    
    func callForgotPasswordAPI() {
        guard passedValidation() else { return }
        
        let params : NSDictionary = [
            apiParams.email : email,
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.ForgotPwd, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            UIApplication.shared.hideLoader()
            
            if error != nil && response == nil {
                UIApplication.shared.showAlertPopup(message: message ?? "")
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                let message = json?[API_MESSAGE] as? String
                
                if status == SUCCESS {
                    self.dismissAction?(message ?? "")
                } else {
                    UIApplication.shared.showAlertPopup(message: message ?? "")
                }
            }
        }
    }
    
    private func passedValidation() -> Bool {
        var flag = false
        let isEmailAddressValid = isValidEmail(email)
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_emailId)
        } else if !isEmailAddressValid {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_invalidEmail)
        } else {
            flag = true
        }
        
        return flag
    }
}
