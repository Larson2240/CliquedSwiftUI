//
//  SignInVC.swift
//  Cliqued
//
//  Created by C211 on 10/01/23.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import Security
import FBSDKLoginKit

class SignInVC: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: Variable
    var dataSource : SignInDataSource?
    lazy var viewModel = SignInViewModel()
    var isFromSignUpScreen: Bool = false
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
//        viewModel.setEmail(value: "@narola.email")
//        viewModel.setPassword(value: "Pass@123")
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
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            let user = signInResult.user
            userDefaults.set(user.profile?.givenName, forKey: UserDefaultKey.userName)
            self.viewModel.setEmail(value: user.profile?.email ?? "")
            self.viewModel.setSocialLoginId(value: user.userID ?? "")
            self.viewModel.setLoginType(value: LoginType.GOOGLE)
            self.viewModel.callSocialLoginAPI()
        }
    }
}
//MARK: Extension UDF
extension SignInVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        dataSource = SignInDataSource(tableView: tableview, viewModel: viewModel, viewController: self)
        tableview.delegate = dataSource
        tableview.dataSource = dataSource
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = ""
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
        viewModel.isMessage.bind { message in
            self.showAlertPopup(message: message)
        }
        
        //If API success
        viewModel.isDataGet.bind { isSuccess in
            if isSuccess {
                if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
                    APP_DELEGATE.socketIOHandler = SocketIOHandler()
                                      
                    let tabbarvc = TabBarVC.loadFromNib()
                    APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: tabbarvc)
                } else {
                    if Constants.loggedInUser?.isVerified == "1" {
                        let welcomevc = WelcomeVC.loadFromNib()
                        APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: welcomevc)
                    } else if Constants.loggedInUser?.profileSetupType == "0" {
                        self.manageSetupProfileNavigationFlow()
                    } else {
                        self.showAlerBox("", Constants.validMsg_emailNotVerified) { _ in }
                    }
                }
            }
        }
        
        //Loader hide & show
        viewModel.isLoaderShow.bind { isLoader in
            if isLoader {
                self.showLoader()
            } else {
                self.dismissLoader()
            }
        }
    }
    
    //MARK: Setup profile navigation flow
    func manageSetupProfileNavigationFlow() {
        let strCount: String?
        if Constants.loggedInUser?.isProfileSetupCompleted == 1 {
            let profile_setup_count = Int((Constants.loggedInUser?.profileSetupType)!)!
            strCount = "\(profile_setup_count)"
        } else {
            let profile_setup_count = Int((Constants.loggedInUser?.profileSetupType)!)! + 1
            strCount = "\(profile_setup_count)"
        }
        switch strCount {
        case ProfileSetupType.name:
            let namevc = NameVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: namevc)
            
        case ProfileSetupType.birthdate:
            let agevc = AgeVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController =  UINavigationController(rootViewController: agevc)
            
        case ProfileSetupType.gender:
            let gendervc = GenderVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: gendervc)
            
        case ProfileSetupType.relationship:
            let relationshipvc = RelationshipVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: relationshipvc)
            
        case ProfileSetupType.category:
            let pickactivityvc = PickActivityVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: pickactivityvc)
            
        case ProfileSetupType.sub_category:
            let picksubactivityvc = PickSubActvityVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: picksubactivityvc)
            
        case ProfileSetupType.profile_images:
            let selectpicturevc = SelectPicturesVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: selectpicturevc)
            
        case ProfileSetupType.location:
            let locationvc = SetLocationVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: locationvc)
            
        case ProfileSetupType.notification_enable:
            let notificationvc = NotificationPermissionVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: notificationvc)
            
        case ProfileSetupType.completed:
            let startexplorevc = StartExploringVC.loadFromNib()
            APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: startexplorevc)
        default:
            break
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
extension SignInVC: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            if appleCredential.fullName != nil, appleCredential.email != nil {
                self.saveCredentialInKeychain(userIdentifier: appleCredential.user, fullName: appleCredential.fullName?.givenName ?? "", email: appleCredential.email ?? "")
            }
            userDefaults.set(KeychainItem.currentUserFullName, forKey: UserDefaultKey.userName)
            viewModel.setEmail(value: KeychainItem.currentUserEmail)
            viewModel.setSocialLoginId(value: appleCredential.user)
            viewModel.setLoginType(value: LoginType.APPLE)
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
