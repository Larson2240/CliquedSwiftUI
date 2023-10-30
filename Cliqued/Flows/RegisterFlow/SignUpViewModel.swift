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
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    @Published var rememberMeSelected = false
    @Published private var loginType = "0"
    @Published private var socialLoginID = ""
    
    private let apiParams = ApiParams()
    private let authWebService = AuthWebService()
    private let userWebService = UserWebService()
    
    func callSignUpAPI() {
        guard signUpValid() else { return }
        
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        authWebService.register(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            UIApplication.shared.hideLoader()
            
            switch result {
            case .success:
                UserDefaults.standard.set(true, forKey: UserDefaultKey().isLoggedIn)
                UserDefaults.standard.set(self.rememberMeSelected, forKey: UserDefaultKey().isRemeberMe)
                
                self.proceed()
            case .failure(let error):
                if let error = error as? ApiError, let errorDesc = error.errorDescription {
                    UIApplication.shared.showAlertPopup(message: errorDesc)
                } else {
                    UIApplication.shared.showAlertPopup(message: error.localizedDescription)
                }
            }
        }
    }
    
    func callSignInAPI() {
        guard signInValid() else { return }
        
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        authWebService.login(email: email,
                             password: password,
                             rememberMe: rememberMeSelected) { [weak self] result in
            guard let self = self else { return }
            
            UIApplication.shared.hideLoader()
            
            switch result {
            case .success:
                UserDefaults.standard.set(true, forKey: UserDefaultKey().isLoggedIn)
                UserDefaults.standard.set(self.rememberMeSelected, forKey: UserDefaultKey().isRemeberMe)
                
                self.proceed()
            case .failure(let error):
                if let error = error as? ApiError, let errorDesc = error.errorDescription {
                    UIApplication.shared.showAlertPopup(message: errorDesc)
                } else {
                    UIApplication.shared.showAlertPopup(message: error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: Social Login API
    func callSocialLoginAPI() {
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        authWebService.social(socialID: socialLoginID, loginType: Int(loginType) ?? 0) { [weak self] result in
            guard let self = self else { return }
            
            UIApplication.shared.hideLoader()
            
            switch result {
            case .success:
                UserDefaults.standard.set(true, forKey: UserDefaultKey().isLoggedIn)
                UserDefaults.standard.set(self.rememberMeSelected, forKey: UserDefaultKey().isRemeberMe)
                
                self.proceed()
            case .failure(let error):
                if let error = error as? ApiError, let errorDesc = error.errorDescription {
                    UIApplication.shared.showAlertPopup(message: errorDesc)
                } else {
                    UIApplication.shared.showAlertPopup(message: error.localizedDescription)
                }
            }
        }
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
        userWebService.getUser { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                loggedInUser = user
                
                if user.profileSetupCompleted() {
                    APP_DELEGATE.socketIOHandler = SocketIOHandler()
                    
                    APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView())
                } else {
                    let welcomevc = UIHostingController(rootView: WelcomeView())
                    APP_DELEGATE.window?.rootViewController = welcomevc
                }
            case .failure(let error):
                print(error.localizedDescription)
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
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        
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

