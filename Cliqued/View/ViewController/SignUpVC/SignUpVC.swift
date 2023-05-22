//
//  SignUpVC.swift
//  Cliqued
//
//  Created by C211 on 10/01/23.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import Security
import FBSDKLoginKit

class SignUpVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: Variable
    var dataSource : SignUpDataSource?
    lazy var viewModel = SignUpViewModel()
    var isFromSignInScreen: Bool = false
    private let loginType = LoginType()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: Google Sign In
    func handleGoogleSignIn() {
        let config = GIDConfiguration(clientID: Constants.googleSignInKey)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
            guard let self = self else { return }
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            let user = signInResult.user
            UserDefaults.standard.set(user.profile?.givenName, forKey: UserDefaultKey().userName)
            self.viewModel.setEmail(value: user.profile?.email ?? "")
            self.viewModel.setSocialLoginId(value: user.userID ?? "")
            self.viewModel.setLoginType(value: self.loginType.GOOGLE)
            self.viewModel.callSocialLoginAPI()
        }
    }
    
}
//MARK: Extension UDF
extension SignUpVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = SignUpDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        handleApiResponse()
    }
    
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_signUp
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = false
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = true
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Handle API response
    func handleApiResponse() {
        
        //Check response message
        viewModel.isMessage.bind { [weak self] message in
            self?.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { [weak self] isSuccess in
            guard let self = self else { return }
            
            if isSuccess {
                if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
                    APP_DELEGATE.socketIOHandler = SocketIOHandler()
                    let tabbarvc = TabBarVC.loadFromNib()
                    APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: tabbarvc)
                } else {
                    if Constants.loggedInUser?.isVerified == "1" {
                        let welcomevc = WelcomeVC.loadFromNib()
                        APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: welcomevc)
                    } else {
                        self.showAlerBox("", Constants.label_emailSentMessage) { _ in
                            let welcomevc = WelcomeVC.loadFromNib()
                            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: welcomevc)
                        }
                    }
                }
            }
        }
        
        //Loader hide & show
        viewModel.isLoaderShow.bind { [weak self] isLoader in
            guard let self = self else { return }
            
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
    }
    
    //MARK: Save apple credential in Keychain
    private func saveCredentialInKeychain(userIdentifier: String, fullName: String, email: String) {
        do {
            try KeychainItem(service: APP_BUNDLE_IDENTIFIRE, account: "userIdentifier").saveItem(userIdentifier)
            try KeychainItem(service: APP_BUNDLE_IDENTIFIRE, account: "fullName").saveItem(fullName)
            try KeychainItem(service: APP_BUNDLE_IDENTIFIRE, account: "email").saveItem(email)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
}
//MARK: Extension Apple Login
extension SignUpVC: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            if appleCredential.fullName != nil, appleCredential.email != nil {
                self.saveCredentialInKeychain(userIdentifier: appleCredential.user, fullName: appleCredential.fullName?.givenName ?? "", email: appleCredential.email ?? "")
            }
            UserDefaults.standard.set(KeychainItem.currentUserFullName, forKey: UserDefaultKey().userName)
            viewModel.setEmail(value: KeychainItem.currentUserEmail)
            viewModel.setSocialLoginId(value: appleCredential.user)
            viewModel.setLoginType(value: loginType.APPLE)
            viewModel.callSocialLoginAPI()
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if let e = error as? ASAuthorizationError {
            switch e.code {
            case .canceled:
                self.showAlertPopup(message: Constants.alertCancelled)
            case .failed:
                self.showAlertPopup(message: Constants.alertAuthorizationFailed)
            case .invalidResponse:
                self.showAlertPopup(message: Constants.alertInvalidResponse)
            case .notHandled:
                self.showAlertPopup(message: Constants.alertAuthorizationNotHandeled)
            case .unknown:
                self.showAlertPopup(message: Constants.alertUnknownResponseFromAppleAuth)
            default:
                self.showAlertPopup(message: Constants.alertUnknownErrorCode)
            }
        }
    }
}
