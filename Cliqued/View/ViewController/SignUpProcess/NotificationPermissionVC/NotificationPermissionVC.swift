//
//  NotificationPermissionVC.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import UIKit
import UserNotifications

class NotificationPermissionVC: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewNavigationBar: NavigationView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelMainTitle: UILabel!{
        didSet {
            labelMainTitle.text = Constants.label_notificationScreenSubTitle
            labelMainTitle.font = CustomFont.THEME_FONT_Bold(20)
            labelMainTitle.textColor = Constants.color_DarkGrey
        }
    }
    @IBOutlet weak var buttonEnableNotification: UIButton!
    @IBOutlet weak var buttonDisableNotification: UIButton!
    @IBOutlet weak var buttonSaveProfile: UIButton!
    
    //MARK: Variable
    lazy var viewModel = SignUpProcessViewModel()
    var isEnableNotification: Bool = false
    var isSystemNotificationEnable: Bool = false
    private let profileSetupType = ProfileSetupType()
    private let notificationPermissionTypeIds = NotificationPermissionTypeIds()
    private let preferenceTypeIds = PreferenceTypeIds()
    
    //MARK: viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadMethod()
    }
    
    //MARK: viewWillAppear Method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setupNotification()
        NotificationCenter.default.addObserver(self, selector: #selector(checkNotificationPermission), name: UIApplication.willEnterForegroundNotification, object: nil)
        //        checkNotificationPermission()
    }
    
    //MARK: viewDidLayoutSubviews Method
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtonUI(buttonName: buttonSaveProfile, buttonTitle: Constants.btn_saveProfile)
    }
    
    //MARK: Button Continue Click Event
    @IBAction func btnSaveProfileTap(_ sender: Any) {
        viewModel.setProfileSetupType(value: profileSetupType.completed)
        UserDefaults.standard.set(true, forKey: UserDefaultKey().isLoggedIn)
        UserDefaults.standard.set(true, forKey: UserDefaultKey().isRemeberMe)
        self.viewModel.callSignUpProcessAPI()
    }
    
    //MARK: Button Enable Notification Click
    @IBAction func btnEnableNotificationTap(_ sender: Any) {
        if !isEnableNotification {
            if isSystemNotificationEnable {
                self.isEnableNotification = true
                self.setupNotificationButtonUI()
                self.managenotificationValue(typeOfOption: notificationPermissionTypeIds.Yes)
            } else {
                if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
        }
    }
    
    //MARK: Button Disable Notification Click
    @IBAction func btnDisableNotificationTap(_ sender: Any) {
        if isEnableNotification {
            alertCustom(btnNo:Constants.btn_cancel, btnYes:Constants.btn_disable, title: Constants.label_notificationDisableTitle, message: Constants.label_notificationDisableMessage) { [weak self] in
                guard let self = self else { return }
                self.isEnableNotification = false
                self.setupNotificationButtonUI()
                self.managenotificationValue(typeOfOption: self.notificationPermissionTypeIds.No)
            }
        }
    }
    
    //MARK: Create notification data dictionary for send in API
    func managenotificationValue(typeOfOption: String) {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfTypeOption = [TypeOptions]()
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == preferenceTypeIds.notification_enable}) ?? []
        if arrayOfPreference.count > 0 {
            arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
            if arrayOfTypeOption.count > 0 {
                arrayOfTypeOption = arrayOfTypeOption.filter({$0.typeOfOptions == typeOfOption})
                var dict = structNotificationParam()
                dict.notificationPreferenceId = arrayOfTypeOption[0].preferenceId?.description ?? ""
                dict.notificationOptionId = arrayOfTypeOption[0].id?.description ?? ""
                self.viewModel.setNotification(value: dict)
            }
        }
    }
    //MARK: function check notification permission
    @objc func checkNotificationPermission() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { [weak self] permission in
            guard let self = self else { return }
            
            switch permission.authorizationStatus  {
            case .authorized:
                print("User granted permission for notification")
                self.isSystemNotificationEnable = true
                self.isEnableNotification = true
                self.setupNotificationButtonUI()
                self.managenotificationValue(typeOfOption: self.notificationPermissionTypeIds.Yes)
            case .denied:
                self.managenotificationValue(typeOfOption: self.notificationPermissionTypeIds.No)
            case .notDetermined:
                print("Notification permission haven't been asked yet")
            case .provisional:
                // @available(iOS 12.0, *)
                print("The application is authorized to post non-interruptive user notifications.")
            case .ephemeral:
                // @available(iOS 14.0, *)
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
            @unknown default:
                print("Unknow Status")
            }
        })
    }
}
//MARK: Extension UDF
extension NotificationPermissionVC {
    
    func viewDidLoadMethod() {
        setupNavigationBar()
        setupProgressView()
        unselectedButtonUI(buttonName: buttonEnableNotification, buttonTitle: Constants.btn_enableNotification)
        unselectedButtonUI(buttonName: buttonDisableNotification, buttonTitle: Constants.btn_disableNotification)
        handleApiResponse()
    }
    //MARK: Setup Navigation Bar
    func setupNavigationBar() {
        viewNavigationBar.backgroundColor = .clear
        viewNavigationBar.labelNavigationTitle.text = Constants.screenTitle_notification
        viewNavigationBar.buttonBack.addTarget(self, action: #selector(buttonBackTap), for: .touchUpInside)
        viewNavigationBar.buttonSkip.addTarget(self, action: #selector(buttonSkipTap), for: .touchUpInside)
        viewNavigationBar.buttonBack.isHidden = true
        viewNavigationBar.buttonRight.isHidden = true
        viewNavigationBar.buttonSkip.isHidden = false
    }
    //MARK: Register notification
    func setupNotification() {
        UIApplication.shared.registerForRemoteNotifications()
        registerForPushNotifications()
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
    }
    //MARK: Back Button Action
    @objc func buttonBackTap() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Back Skip Action
    @objc func buttonSkipTap() {
        APP_DELEGATE.setTabBarRootViewController()
    }
    //MARK: Setup ProgressView progress
    func setupProgressView() {
        let currentProgress = 9
        progressView.progress = Float(currentProgress)/Float(maxProgress)
    }
    //MARK: Setup notification buttonUI
    func setupNotificationButtonUI() {
        if isEnableNotification {
            selectedButtonUI(buttonName: buttonEnableNotification, buttonTitle: Constants.btn_enableNotification)
            unselectedButtonUI(buttonName: buttonDisableNotification, buttonTitle: Constants.btn_disableNotification)
        } else {
            selectedButtonUI(buttonName: buttonDisableNotification, buttonTitle: Constants.btn_disableNotification)
            unselectedButtonUI(buttonName: buttonEnableNotification, buttonTitle: Constants.btn_enableNotification)
        }
    }
    //MARK: Selected buttonUI
    func selectedButtonUI(buttonName: UIButton, buttonTitle: String) {
        DispatchQueue.main.async {
            buttonName.setTitle(buttonTitle, for: .normal)
            buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonName.setTitleColor(Constants.color_white, for: .normal)
            buttonName.backgroundColor = Constants.color_GreenSelectedBkg
            buttonName.layer.cornerRadius = 8.0
        }
    }
    //MARK: Unselected buttonUI
    func unselectedButtonUI(buttonName: UIButton, buttonTitle: String) {
        DispatchQueue.main.async {
            buttonName.setTitle(buttonTitle, for: .normal)
            buttonName.titleLabel?.font = CustomFont.THEME_FONT_Medium(15)
            buttonName.setTitleColor(Constants.color_DarkGrey, for: .normal)
            buttonName.backgroundColor = Constants.color_GreyUnselectedBkg
            buttonName.layer.cornerRadius = 8.0
        }
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
                let startExploringVC = StartExploringVC.loadFromNib()
                self.navigationController?.pushViewController(startExploringVC, animated: true)
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
}
//MARK: Extension Push Notification
extension NotificationPermissionVC: UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            guard let self = self else { return }
            
            self.isSystemNotificationEnable = granted
            self.isEnableNotification = granted
            self.setupNotificationButtonUI()
            if granted {
                self.managenotificationValue(typeOfOption: self.notificationPermissionTypeIds.Yes)
            } else {
                self.managenotificationValue(typeOfOption: self.notificationPermissionTypeIds.No)
            }
        }
    }
    
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device Token: \(deviceTokenString)")
        UserDefaults.standard.set(deviceTokenString, forKey: kDeviceToken)
    }
    
    func application(_ application: UIApplication,didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.badge, .alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        let data = response.notification.request.content.userInfo
    }
}
