//
//  SignUpViewModel.swift
//  Cliqued
//
//  Created by C211 on 12/01/23.
//

import Combine
import GoogleSignIn
import AuthenticationServices

final class SignUpViewModel: NSObject, ObservableObject {
    @Published var isLoading = true
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var rememberMeSelected = false
    @Published var messageToShow = ""
    @Published private var loginType = "0"
    @Published private var socialLoginID = ""
    
    private let apiParams = ApiParams()
    
    //MARK: Check Validation
    func checkValidation() -> Bool {
        var flag = false
        let isEmailAddressValid = isValidEmail(email)
        let isPasswordValid = isPasswordHasNumberAndCharacter(password: password)
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            messageToShow = Constants.validMsg_emailId
        } else if !isEmailAddressValid {
            messageToShow = Constants.validMsg_invalidEmail
        } else if password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            messageToShow = Constants.validMsg_password
        } else if !isPasswordValid {
            messageToShow = Constants.validMsg_invalidPassword
        } else if repeatPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            messageToShow = Constants.validMsg_repeatPassword
        }  else if password != repeatPassword {
            messageToShow = Constants.validMsg_passwordNotMatche
        } else {
            flag = true
        }
        return flag
    }
    
    //MARK: Call Update Profile API
    func callSignUpAPI() {
        guard checkValidation() else { return }
        
        let params: NSDictionary = [
            apiParams.email: email,
            apiParams.password: password,
            apiParams.loginType: loginType
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            messageToShow = Constants.alert_InternetConnectivity
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.SignUp, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            self.isLoading = false
            if error != nil && response == nil {
                self.messageToShow = message ?? ""
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
                                self.saveUser(user: objUser)
                                UserDefaults.standard.set(userToken, forKey: kUserToken)
                                self.proceed()
                            } catch {
                                print(error.localizedDescription)
                            }
                            self.proceed()
                        } else {
                            self.proceed()
                        }
                    }
                } else {
                    self.messageToShow = message ?? ""
                }
            }
        }
    }
    
    func callSignInAPI() {
        guard checkValidation() else { return }
        
        let params: NSDictionary = [
            apiParams.email: email,
            apiParams.password: password,
            apiParams.loginType: loginType
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            messageToShow = Constants.alert_InternetConnectivity
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.Login, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if error != nil && response == nil {
                self.messageToShow = message ?? ""
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
                                self.saveUser(user: objUser)
                                UserDefaults.standard.set(userToken, forKey: kUserToken)
                                UserDefaults.standard.set(appToken, forKey: kAppToken)
                                UserDefaults.standard.set(true, forKey: UserDefaultKey().isLoggedIn)
                                
                                self.proceed()
                            } catch {
                                print(error.localizedDescription)
                            }
                            self.proceed()
                        } else {
                            self.proceed()
                        }
                    }
                } else if status == PASSWORD_WRONG {
                    self.messageToShow = message ?? ""
                } else {
                    self.messageToShow = message ?? ""
                }
            }
        }
    }
    
    //MARK: Social Login API
    func callSocialLoginAPI() {
        let params: NSDictionary = [
            apiParams.email: email,
            apiParams.social_id: socialLoginID,
            apiParams.loginType: loginType
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            messageToShow = Constants.alert_InternetConnectivity
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.SocialLogin, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            self.isLoading = false
            if error != nil && response == nil {
                self.messageToShow = message ?? ""
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
                                self.saveUser(user: objUser)
                                UserDefaults.standard.set(userToken, forKey: kUserToken)
                                UserDefaults.standard.set(appToken, forKey: kAppToken)
                                
                                self.proceed()
                            } catch {
                                print(error.localizedDescription)
                            }
                            self.proceed()
                        } else {
                            self.proceed()
                        }
                    }
                } else {
                    self.messageToShow = message ?? ""
                }
            }
        }
    }
    
    private func saveUser(user: User){
        Constants.saveUserInfoAndProceed(user: user)
    }
    
    private func saveCredentialInKeychain(userIdentifier: String, fullName: String, email: String) {
        do {
            try KeychainItem(service: APP_BUNDLE_IDENTIFIRE, account: "userIdentifier").saveItem(userIdentifier)
            try KeychainItem(service: APP_BUNDLE_IDENTIFIRE, account: "fullName").saveItem(fullName)
            try KeychainItem(service: APP_BUNDLE_IDENTIFIRE, account: "email").saveItem(email)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func proceed() {
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            APP_DELEGATE.socketIOHandler = SocketIOHandler()
            let tabbarvc = TabBarVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: tabbarvc)
        } else {
            if Constants.loggedInUser?.isVerified == "1" {
                let welcomevc = WelcomeVC.loadFromNib()
                APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: welcomevc)
            } else {
                UIApplication.shared.showAlerBox("", Constants.label_emailSentMessage) { _ in
                    let welcomevc = WelcomeVC.loadFromNib()
                    APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: welcomevc)
                }
            }
        }
    }
}

extension SignUpViewModel {
    func googleSignIn() {
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
        
        let config = GIDConfiguration(clientID: Constants.googleSignInKey)
        
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] signInResult, error in
            guard let self = self else { return }
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            let user = signInResult.user
            UserDefaults.standard.set(user.profile?.givenName, forKey: UserDefaultKey().userName)
            self.email = user.profile?.email ?? ""
            self.socialLoginID = user.userID ?? ""
            self.loginType = LoginType().GOOGLE
            self.callSocialLoginAPI()
        }
    }
    
    func appleSignIn() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension SignUpViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            if appleCredential.fullName != nil, appleCredential.email != nil {
                saveCredentialInKeychain(userIdentifier: appleCredential.user, fullName: appleCredential.fullName?.givenName ?? "", email: appleCredential.email ?? "")
            }
            
            UserDefaults.standard.set(KeychainItem.currentUserFullName, forKey: UserDefaultKey().userName)
            
            email = KeychainItem.currentUserEmail
            socialLoginID = appleCredential.user
            loginType = LoginType().APPLE
            callSocialLoginAPI()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else { return }
        
        switch error.code {
        case .canceled:
            UIApplication.shared.showAlertPopup(message: Constants.alertCancelled)
        case .failed:
            UIApplication.shared.showAlertPopup(message: Constants.alertAuthorizationFailed)
        case .invalidResponse:
            UIApplication.shared.showAlertPopup(message: Constants.alertInvalidResponse)
        case .notHandled:
            UIApplication.shared.showAlertPopup(message: Constants.alertAuthorizationNotHandeled)
        case .unknown:
            UIApplication.shared.showAlertPopup(message: Constants.alertUnknownResponseFromAppleAuth)
        default:
            UIApplication.shared.showAlertPopup(message: Constants.alertUnknownErrorCode)
        }
    }
}

