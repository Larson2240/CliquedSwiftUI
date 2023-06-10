//
//  SignUpViewModel.swift
//  Cliqued
//
//  Created by C211 on 12/01/23.
//

import SwiftUI
import Combine
import GoogleSignIn
import AuthenticationServices

final class SignUpViewModel: NSObject, ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var rememberMeSelected = false
    @Published private var loginType = "0"
    @Published private var socialLoginID = ""
    
    private let apiParams = ApiParams()
    
    func callSignUpAPI() {
        guard signUpValid() else { return }
        
        let params: NSDictionary = [
            apiParams.email: email,
            apiParams.password: password,
            apiParams.loginType: loginType
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.SignUp, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            UIApplication.shared.hideLoader()
            if error != nil && response == nil {
                UIApplication.shared.showAlertPopup(message: message ?? "")
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
                    UIApplication.shared.showAlertPopup(message: message ?? "")
                }
            }
        }
    }
    
    func callSignInAPI() {
        guard signInValid() else { return }
        
        let params: NSDictionary = [
            apiParams.email: email,
            apiParams.password: password,
            apiParams.loginType: loginType
        ]
        
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.Login, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            UIApplication.shared.hideLoader()
            
            if error != nil && response == nil {
                UIApplication.shared.showAlertPopup(message: message ?? "")
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
                    UIApplication.shared.showAlertPopup(message: message ?? "")
                } else {
                    UIApplication.shared.showAlertPopup(message: message ?? "")
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
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.SocialLogin, parameters: params) { [weak self] response, error, message in
            guard let self = self else { return }
            
            UIApplication.shared.hideLoader()
            
            if error != nil && response == nil {
                UIApplication.shared.showAlertPopup(message: message ?? "")
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
                    UIApplication.shared.showAlertPopup(message: message ?? "")
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
            let tabBarVC = TabBarVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: tabBarVC)
        } else {
            if Constants.loggedInUser?.isVerified == "1" {
                let welcomevc = UIHostingController(rootView: WelcomeView())
                APP_DELEGATE.window?.rootViewController = welcomevc
            } else {
                UIApplication.shared.showAlerBox("", Constants.label_emailSentMessage) { _ in
                    let welcomevc = UIHostingController(rootView: WelcomeView())
                    APP_DELEGATE.window?.rootViewController = welcomevc
                }
            }
        }
    }
}

// MARK: - Validation
extension SignUpViewModel {
    private func signUpValid() -> Bool {
        var flag = false
        let isEmailAddressValid = isValidEmail(email)
        let isPasswordValid = isPasswordHasNumberAndCharacter(password: password)
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_emailId)
        } else if !isEmailAddressValid {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_invalidEmail)
        } else if password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_password)
        } else if !isPasswordValid {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_invalidPassword)
        } else if repeatPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_repeatPassword)
        }  else if password != repeatPassword {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_passwordNotMatche)
        } else {
            flag = true
        }
        return flag
    }
    
    private func signInValid() -> Bool {
        var flag = false
        let isEmailAddressValid = isValidEmail(email)
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_emailId)
        } else if !isEmailAddressValid {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_invalidEmail)
        } else if password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_password)
        } else {
            flag = true
        }
        return flag
    }
}

// MARK: - Social sign in
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

