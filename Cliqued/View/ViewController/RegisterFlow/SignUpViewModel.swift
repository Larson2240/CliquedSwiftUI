//
//  SignUpViewModel.swift
//  Cliqued
//
//  Created by C211 on 12/01/23.
//

import Combine

class SignUpViewModel: ObservableObject {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var rememberMeSelected = false
    
    private let apiParams = ApiParams()
    
    //MARK: Variables
    private var isRememberMe = false
    
    private struct signupParams {
        var email = ""
        var password = ""
        var confirmPassword = ""
        var socialLoginId = ""
        var loginType = "0"
    }
    private var structSignUpValue = signupParams()
    
    //MARK: Check Validation
    func checkValidation() -> Bool {
        var flag = false
        let isEmailAddressValid = isValidEmail(structSignUpValue.email)
        let isPasswordValid = isPasswordHasNumberAndCharacter(password: structSignUpValue.password)
        if structSignUpValue.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isMessage.value = Constants.validMsg_emailId
        } else if !isEmailAddressValid {
            self.isMessage.value = Constants.validMsg_invalidEmail
        } else if structSignUpValue.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isMessage.value = Constants.validMsg_password
        } else if !isPasswordValid {
            self.isMessage.value = Constants.validMsg_invalidPassword
        } else if structSignUpValue.confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isMessage.value = Constants.validMsg_repeatPassword
        }  else if structSignUpValue.password != structSignUpValue.confirmPassword {
            self.isMessage.value = Constants.validMsg_passwordNotMatche
        } else {
            flag = true
        }
        return flag
    }
    
    
    //MARK: Call Update Profile API
    func callSignUpAPI() {
        guard checkValidation() else { return }
        let params: NSDictionary = [
            apiParams.email : self.getEmail(),
            apiParams.password : self.getPassword(),
            apiParams.loginType : self.getLoginType()
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            isMessage.value = Constants.alert_InternetConnectivity
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.isLoaderShow.value = true
        }
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.SignUp, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            self.isLoaderShow.value = false
            if(error != nil && response == nil) {
                self.isMessage.value = message ?? ""
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                let message = json?[API_MESSAGE] as? String
                let userToken = json?["user_token"] as? String
                
                
                if status == SUCCESS {
                    if let userArray = json?["user"] as? NSArray {
                        if userArray.count > 0 {
                            let dicUser = userArray[0] as! NSDictionary
                            let decoder = JSONDecoder()
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                let objUser = try decoder.decode(User.self, from: jsonData)
                                self.saveUserInfoAndProceed(user: objUser)
                                UserDefaults.standard.set(userToken, forKey: kUserToken)
                                self.isDataGet.value = true
                            } catch {
                                print(error.localizedDescription)
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
    }
    
    //MARK: Social Login API
    func callSocialLoginAPI() {
        let params: NSDictionary = [
            apiParams.email : self.getEmail(),
            apiParams.social_id : self.getSocialLoginId(),
            apiParams.loginType : self.getLoginType()
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            isMessage.value = Constants.alert_InternetConnectivity
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoaderShow.value = true
        }
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.SocialLogin, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            self.isLoaderShow.value = false
            if error != nil && response == nil {
                self.isMessage.value = message ?? ""
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                let message = json?[API_MESSAGE] as? String
                let userToken = json?["user_token"] as? String
                let appToken = json?["app_token"] as? String
                
                if status == SUCCESS {
                    if let userArray = json?["user"] as? NSArray {
                        if userArray.count > 0 {
                            let dicUser = userArray[0] as! NSDictionary
                            let decoder = JSONDecoder()
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                let objUser = try decoder.decode(User.self, from: jsonData)
                                self.saveUserInfoAndProceed(user: objUser)
                                UserDefaults.standard.set(userToken, forKey: kUserToken)
                                UserDefaults.standard.set(appToken, forKey: kAppToken)
                                self.isDataGet.value = true
                            } catch {
                                print(error.localizedDescription)
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
    }
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User){
        Constants.saveUserInfoAndProceed(user: user)
    }
}
//MARK: getter/setter method
extension SignUpViewModel {
    
    //Get methods
    func getEmail() -> String {
        structSignUpValue.email
    }
    func getPassword() -> String {
        structSignUpValue.password
    }
    func getConfirmPassword() -> String {
        structSignUpValue.confirmPassword
    }
    func getSocialLoginId() -> String {
        structSignUpValue.socialLoginId
    }
    func getLoginType() -> String {
        structSignUpValue.loginType
    }
    func getRememberMe() -> Bool {
        isRememberMe
    }
    
    //Set methods
    func setEmail(value: String) {
        structSignUpValue.email = value
    }
    func setPassword(value: String) {
        structSignUpValue.password = value
    }
    func setConfirmPassword(value: String) {
        structSignUpValue.confirmPassword = value
    }
    func setSocialLoginId(value: String) {
        structSignUpValue.socialLoginId = value
    }
    func setLoginType(value: String) {
        structSignUpValue.loginType = value
    }
    func setRememberMe(value: Bool) {
        isRememberMe = value
    }
}
