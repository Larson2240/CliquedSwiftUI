//
//  SignInViewModel.swift
//  Cliqued
//
//  Created by C211 on 11/01/23.
//


import UIKit

class SignInViewModel {
    
    var isMessage: Dynamic<String> = Dynamic(String())
    var isLoaderShow: Dynamic<Bool> = Dynamic(true)
    var isDataGet: Dynamic<Bool> = Dynamic(false)
    
    //MARK: Variables
    private struct loginParams {
        var fullName = ""
        var socialLoginId = ""
        var email = ""
        var password = ""
        var profileImage = UIImage()
        var loginType = "0"
    }
    
    private var isRememberMe = false
    private var structSignInValue = loginParams()
    private var wrongPasswordCount = 0
    private let apiParams = ApiParams()
    
    //MARK: Check Validation
    func checkValidation() -> Bool {
        var flag = false
        let isEmailAddressValid = isValidEmail(structSignInValue.email)
        if structSignInValue.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isMessage.value = Constants.validMsg_emailId
        } else if !isEmailAddressValid {
            self.isMessage.value = Constants.validMsg_invalidEmail
        } else if structSignInValue.password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.isMessage.value = Constants.validMsg_password
        } else {
            flag = true
        }
        return flag
    }
    
    //MARK: Call SignIn API
    func callSignInAPI() {
        
        if checkValidation() {
            let params: NSDictionary = [
                apiParams.email : self.getEmail(),
                apiParams.password : self.getPassword(),
                apiParams.loginType : self.getLoginType()
            ]
            
            if(Connectivity.isConnectedToInternet()){
                DispatchQueue.main.async { [weak self] in
                    self?.isLoaderShow.value = true
                }
                RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.Login, parameters: params) { [weak self] response, error, message in
                    guard let self = self else { return }
                    
                    self.isLoaderShow.value = false
                    if(error != nil && response == nil) {
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
                                        UserDefaults.standard.set(true, forKey: UserDefaultKey().isLoggedIn)
                                        self.isDataGet.value = true
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                    self.isDataGet.value = true
                                } else {
                                    self.isDataGet.value = true
                                }
                            }
                        } else if status == PASSWORD_WRONG {
                            self.setWrongPasswordCount()
                            self.isMessage.value = message ?? ""
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
    
    //MARK: Social Login API
    func callSocialLoginAPI() {
        
        let params: NSDictionary = [
            apiParams.email : self.getEmail(),
            apiParams.social_id : self.getSocialLoginId(),
            apiParams.loginType : self.getLoginType()
        ]
        
        if(Connectivity.isConnectedToInternet()){
            DispatchQueue.main.async { [weak self] in
                self?.isLoaderShow.value = true
            }
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.SocialLogin, parameters: params) { [weak self] response, error, message in
                guard let self = self else { return }
                
                self.isLoaderShow.value = false
                if(error != nil && response == nil) {
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
                                    UserDefaults.standard.set(userToken, forKey: kUserToken)
                                    UserDefaults.standard.set(appToken, forKey: kAppToken)
                                    self.saveUserInfoAndProceed(user: objUser)
                                    if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
                                        UserDefaults.standard.set(true, forKey: UserDefaultKey().isLoggedIn)
                                        UserDefaults.standard.set(true, forKey: UserDefaultKey().isRemeberMe)
                                    }
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
    }
    
    //MARK: Save user data in UserDefault
    func saveUserInfoAndProceed(user: User){
        Constants.saveUserInfoAndProceed(user: user)
    }
}

//MARK: getter/setter method
extension SignInViewModel {
    
    //Get methods
    func getFullName() -> String {
        structSignInValue.fullName
    }
    func getSocialLoginId() -> String {
        structSignInValue.socialLoginId
    }
    func getEmail() -> String {
        structSignInValue.email
    }
    func getPassword() -> String {
        structSignInValue.password
    }
    func getProfileImage() -> UIImage {
        structSignInValue.profileImage
    }
    func getLoginType() -> String {
        structSignInValue.loginType
    }
    func getRememberMe() -> Bool {
        isRememberMe
    }
    func getWrongPasswordCount() -> Int {
        wrongPasswordCount
    }
    
    //Set methods
    func setFullName(value: String) {
        structSignInValue.fullName = value
    }
    func setSocialLoginId(value: String) {
        structSignInValue.socialLoginId = value
    }
    func setEmail(value: String) {
        structSignInValue.email = value
    }
    func setPassword(value: String) {
        structSignInValue.password = value
    }
    func setProfileImage(value: UIImage) {
        structSignInValue.profileImage = value
    }
    func setLoginType(value: String) {
        structSignInValue.loginType = value
    }
    func setRememberMe(value: Bool) {
        isRememberMe = value
    }
    func setWrongPasswordCount() {
        wrongPasswordCount = wrongPasswordCount + 1
    }
    func setResetWrongPasswordCount() {
        wrongPasswordCount = 0
    }
}
