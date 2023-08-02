//
//  AppDelegate.swift
//  Cliqued
//
//  Created by C211 on 10/01/23.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import IQKeyboardManager
import Firebase
import PushKit
import CallKit
import TwilioVideo
import GoogleMobileAds
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var socketIOHandler:SocketIOHandler?
    var socketHandlersAdded = false
    var providerDelegate =  ProviderDelegate()
    var isCallOn = false
    var ongoingUUID : UUID?
    var timerCallDeclined : Timer?
    var voip_token = ""
    var device_token = ""
    var languageBundle : Bundle?
    var textLog = TextLog()
    var bgTask: UIBackgroundTaskIdentifier?
    var updateTimer : Timer?
    var audioDevice = DefaultAudioDevice()
    var audioSession = AVAudioSession.sharedInstance()
    private let apiParams = ApiParams()
    private let preferenceOptionIds = PreferenceOptionIds()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //MARK: Initialize the Google Mobile Ads SDK.
        DispatchQueue.global().async {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //MARK: Setup Firebase
        FirebaseApp.configure()
        
        //MARK: Setup Notification
        voipRegistration()
        
        //MARK: Mannage for Facebook Login
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        //MARK: Setup Keyboard
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        //MARK: Get preference data
        callGetPreferenceDataAPI()
        
        //MARK: Managed Security and login flow
        checkSecurity()
        setRootViewController()
        
        TwilioVideoSDK.audioDevice = audioDevice
        return true
    }
    
    //MARK: Setup rootViewController
    func setRootViewController() {
        if UserDefaults.standard.bool(forKey: UserDefaultKey().isLoggedIn) && UserDefaults.standard.bool(forKey: UserDefaultKey().isRemeberMe) {
            setLanguage()
            socketIOHandler = SocketIOHandler()
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView())
        } else {
            setLanguage()
            let registerOptionsView = UIHostingController(rootView: RegisterOptionsView())
            APP_DELEGATE.window?.rootViewController = registerOptionsView
        }
    }
    
    //MARK: Setup TabbarVC rootViewController
    func setTabBarRootViewController() {
        setLanguage()
        socketIOHandler = SocketIOHandler()
        APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView())
    }
    
    //MARK: Setup RegisterOptionVC rootViewController
    func setRegisterOptionRootViewController() {
        setLanguage()
        let registerOptionsView = UIHostingController(rootView: RegisterOptionsView())
        APP_DELEGATE.window?.rootViewController = registerOptionsView
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if socketIOHandler != nil{
            socketIOHandler?.background()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if socketIOHandler != nil {
            socketIOHandler?.foreground()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if UserDefaults.standard.bool(forKey: UserDefaultKey().isLoggedIn) && UserDefaults.standard.bool(forKey: UserDefaultKey().isRemeberMe) == false {
            UserDefaults.standard.clearUserDefault()
        }
        
        if Calling.is_host == "1" {
            self.providerDelegate.RejectSessionSub(callStatus: enumCallStatus.ended.rawValue)
        } else {
            self.providerDelegate.RejectSessionSub(callStatus: enumCallStatus.rejected.rawValue)
        }
        
        APP_DELEGATE.socketIOHandler?.disconnectSocket()
    }
    
    func application(
        _ app: UIApplication,
        open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        return false
    }
    
    //MARK: Call Get Preferences Data API
    func callGetPreferenceDataAPI() {
        guard Connectivity.isConnectedToInternet() else {
            if let topVC = UIApplication.getTopViewController() {
                topVC.showAlertPopup(message: Constants.alert_InternetConnectivity)
            }
            return
        }
        
        RestApiManager.sharePreference.getResponseWithoutParams(webUrl: APIName.GetMasterPreferenceAPI) { [weak self] response, error, message in
            guard let self = self else { return }
            
            if error != nil && response == nil {
            } else {
                let json = response as? NSDictionary
                let status = json?[API_STATUS] as? Int
                _ = json?[API_MESSAGE] as? String
                
                if status == SUCCESS, let preferenceArray = json?["preference_types"] as? NSArray, preferenceArray.count > 0 {
                    var arrayOfPreferences = [PreferenceClass]()
                    
                    for preferenceInfo in preferenceArray {
                        let dicPreference = preferenceInfo as! NSDictionary
                        let decoder = JSONDecoder()
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject:dicPreference)
                            let preferenceData = try decoder.decode(PreferenceClass.self, from: jsonData)
                            arrayOfPreferences.append(preferenceData)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    self.savePreferenceData(preference: arrayOfPreferences)
                }
            }
        }
    }
    
    //MARK: Save preference data in UserDefault
    func savePreferenceData(preference: [PreferenceClass]){
        Constants.savePreferenceData(preferene: preference)
    }
    
    //MARK: - Get device language
    func setLanguage() {
        getLanguage()
        var selectedLanguage = Language1.en.rawValue
        var strLang = LanguageStrCode.en.rawValue
        
        switch LanguageStrCode(rawValue: UserDefaults.standard.string(forKey: "language")!) {
        case .en:
            selectedLanguage = Language1.en.rawValue
            strLang = LanguageStrCode.en.rawValue
            break
            
        case .fr:
            selectedLanguage = Language1.fr.rawValue
            strLang = LanguageStrCode.fr.rawValue
            break
            
        case .it:
            selectedLanguage = Language1.it.rawValue
            strLang = LanguageStrCode.it.rawValue
            break
            
        case .de:
            selectedLanguage = Language1.de.rawValue
            strLang = LanguageStrCode.de.rawValue
            break
            
        default:
            break
        }
        
        UserDefaults.standard.set(strLang, forKey: "i18n_language")
        UserDefaults.standard.set(selectedLanguage, forKey: USER_DEFAULT_KEYS.kUserLanguage)
        UserDefaults.standard.synchronize()
        
        Constants = Constants_String()
        Constants_Message = Constants_Message1()
    }
    
    //MARK: - Get device language
    func getLanguage() {
        let languageCode = UserDefaults.standard
        if UserDefaults.standard.value(forKey: "language") != nil {
            var language = languageCode.string(forKey: "language")!
            
            if Locale.currentLanguageCode == nil {
                languageCode.set("en", forKey: "language")
                languageCode.synchronize()
                languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            } else {
                if language != Locale.currentLanguageCode?.rawValue {
                    languageCode.set(Locale.currentLanguageCode?.rawValue, forKey: "language")
                    languageCode.synchronize()
                    language = languageCode.string(forKey: "language")!
                }
                if let path  = Bundle.main.path(forResource: language, ofType: "lproj") {
                    languageBundle = Bundle(path: path)
                } else {
                    languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
                }
            }
        } else {
            if Locale.currentLanguageCode != nil {
                languageCode.set(Locale.currentLanguageCode?.rawValue, forKey: "language")
                languageCode.synchronize()
                let language = languageCode.string(forKey: "language")!
                if let path  = Bundle.main.path(forResource: language, ofType: "lproj") {
                    languageBundle =  Bundle(path: path)
                }
                else{
                    languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
                }
            } else {
                languageCode.set("en", forKey: "language")
                languageCode.synchronize()
                languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            }
        }
        Constants = Constants_String()
        Constants_Message = Constants_Message1()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if UserDefaults.standard.bool(forKey: UserDefaultKey().isLoggedIn) {
            UIApplication.shared.applicationIconBadgeNumber += 1
            
            let state = UIApplication.shared.applicationState
            if state == .background || state == .inactive {
                
            } else if state == .active {
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
            
            if UIApplication.getTopViewController() is MessageVC {
                completionHandler([])
            } else {
                completionHandler([.alert, .badge, .sound])
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        if let data = userInfo["aps"] as? [String: Any] {
            if let notificationType = data["notification_type"] as? String {
                
                switch enumNotificationType(rawValue: notificationType) {
                    
                case .newMatches:
                    setLanguage()
                    APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView(selectedIndex: 2))
                    break
                    
                case .message:
                    setLanguage()
                    APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView(selectedIndex: 2))
                    break
                    
                case .userLikesActivity:
                    setLanguage()
                    APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView(selectedIndex: 1))
                    break
                    
                case .CreatorAcceptActivityRequest:
                    setLanguage()
                    APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView(selectedIndex: 2))
                    break
                    
                case .CreatorRejectActivityRequest:
                    setLanguage()
                    APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView(selectedIndex: 1))
                    break
                    
                default:
                    setLanguage()
                    APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView(selectedIndex: 2))
                    break
                }
            } else {
                setLanguage()
                APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView(selectedIndex: 2))
            }
        } else {
            setLanguage()
            
            APP_DELEGATE.window?.rootViewController = UIHostingController(rootView: TabBarView(selectedIndex: 2))
        }
        completionHandler()
    }
}

extension AppDelegate : PKPushRegistryDelegate {
    
    // Register for VoIP notifications
    func voipRegistration() {
        
        // Create a push registry object
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    func registerForPushNotifications() {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self
            
            //Remove all pending and delivered notifications
            notificationCenter.removeAllDeliveredNotifications()
            notificationCenter.removeAllPendingNotificationRequests()
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            notificationCenter.requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIApplication.shared.registerForRemoteNotifications()
        }
        
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        voipRegistry.delegate = self
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        device_token = tokenParts.joined()
        UserDefaults.standard.setValue(device_token, forKey: kDeviceToken)
        print("deviceToken :\(device_token)")
        
        if UserDefaults.standard.bool(forKey: UserDefaultKey().isLoggedIn) {
            checkPushNotificationEnabled()
        }
    }
    
    func checkPushNotificationEnabled() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    self.callUpdateUserDeviceTokenAPI(is_enabled: false)
                }
                // Notification permission has not been asked yet, go for it!
            } else if settings.authorizationStatus == .denied {
                
                DispatchQueue.main.async {
                    self.callUpdateUserDeviceTokenAPI(is_enabled: false)
                }
                
                // Notification permission was previously denied, go to settings & privacy to re-enable
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.callUpdateUserDeviceTokenAPI(is_enabled: true)
                }
            }
        })
    }
    
    //MARK: Call Get Preferences Data API
    func callUpdateUserDeviceTokenAPI(is_enabled: Bool) {
        
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
            apiParams.deviceType: "1",
            apiParams.deviceToken : UserDefaults.standard.object(forKey: kDeviceToken) ?? "123",
            apiParams.voipToken: UserDefaults.standard.object(forKey: USER_DEFAULT_KEYS.VOIP_TOKEN) ?? "123",
            apiParams.isPushEnabled : is_enabled ? "\(preferenceOptionIds.yes)" : "\(preferenceOptionIds.no)"
        ]
        
        if(Connectivity.isConnectedToInternet()) {
            
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.UpdateNotificationToken, parameters: params) { response, error, message in
                if(error != nil && response == nil) {
                    
                } else {
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    let msg = json?[API_MESSAGE] as? String
                    
                    if status == SUCCESS {
                        
                        if let userArray = json?["user"] as? NSArray {
                            if userArray.count > 0 {
                                let dicUser = userArray[0] as! NSDictionary
                                let decoder = JSONDecoder()
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject:dicUser)
                                    let objUser = try decoder.decode(User.self, from: jsonData)
                                    Constants.saveUserInfoAndProceed(user: objUser)
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func callLogoutAPI() {
        let params: NSDictionary = [
            apiParams.userID : "\(Constants.loggedInUser?.id ?? 0)",
        ]
        
        if(Connectivity.isConnectedToInternet()){
            RestApiManager.sharePreference.postJSONFormDataRequest(endpoint: APIName.Logout, parameters: params) { response, error, message in
                
                if(error != nil && response == nil) {
                    
                } else {
                    
                    let json = response as? NSDictionary
                    let status = json?[API_STATUS] as? Int
                    
                    if status == SUCCESS {
                        UserDefaults.standard.clearUserDefaultWithSocket()
                    }
                }
            }
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        print(credentials.token)
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        voip_token = deviceToken
        UserDefaults.standard.set(deviceToken, forKey: USER_DEFAULT_KEYS.VOIP_TOKEN)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("pushRegistry:didInvalidatePushTokenForType:")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        let tempUUid = UUID()
        
        if UserDefaults.standard.bool(forKey: UserDefaultKey().isLoggedIn) {
            
            if let data =  payload.dictionaryPayload["data"] as? NSDictionary {
                if let dic =  data["payload"] as? NSDictionary
                {
                    var temp = callingStruct()
                    
                    temp.room_sid = dic["room_sid"] as? String ?? ""
                    temp.room_Name = dic["room_name"] as? String ?? ""
                    temp.sender_access_token = dic["sender_access_token"] as? String ?? ""
                    temp.callId = dic["call_id"] as? String ?? ""
                    temp.privateRoom = dic["private_room"] as? String ?? ""
                    temp.isHost = dic["is_host"] as? String ?? ""
                    temp.uuid = dic["uuid"] as? String ?? ""
                    
                    temp.is_audio_call = (dic["is_audio_call"] as? String ?? "")
                    temp.sender_profile = dic["sender_profile"] as? String ?? ""
                    
                    let isAudio = temp.is_audio_call == "1" ? true : false
                    if (dic["action"] as? Int ?? 0) == 1 {
                        
                        ongoingUUID = tempUUid
                        var name = String()
                        name = dic["sender_name"] as? String ?? ""
                        temp.sender_name = name
                        
                        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                        
                        UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                        
                        runCallDeclinedTimer()
                        self.displayIncomingCall(uuid: tempUUid, handle: "\(name)", hasVideo: isAudio,temp:temp) { (err) in
                            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                        }
                        
                    } else if (dic["action"] as? Int ?? 0) == 0 {
                        
                        if let id = ongoingUUID {
                            
                            self.providerDelegate.Providerinvalide(uuid: UUID())
                            
                            if "\(dic["call_status"] ?? "0")" == enumCallStatus.received.rawValue || "\(dic["call_status"] ?? "0")" == enumCallStatus.calling.rawValue {
                                
                            } else {
                                
                                if let topVC = UIApplication.getTopViewController(), topVC is VideoCallVC {
                                    topVC.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                        } else {
                            if "\(dic["call_status"] ?? "0")" == enumCallStatus.received.rawValue || "\(dic["call_status"] ?? "0")" == enumCallStatus.calling.rawValue {
                                
                            } else {
                                NotificationCenter.default.post(name: .rejectCall, object:nil)
                                
                            }
                        }
                    } else if (dic["action"] as? Int ?? 0) == 2 {
                        
                        if let id = ongoingUUID {
                            
                            
                            self.providerDelegate.Providerinvalide(uuid: UUID())
                            
                            if "\(dic["call_status"] ?? "0")" == enumCallStatus.received.rawValue || "\(dic["call_status"] ?? "0")" == enumCallStatus.calling.rawValue {
                                
                                
                            } else {
                                
                                if let topVC = UIApplication.getTopViewController(), topVC is VideoCallVC {
                                    topVC.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func runCallDeclinedTimer() {
        timerCallDeclined?.invalidate()
        timerCallDeclined = Timer.scheduledTimer(timeInterval: 30, target: self, selector: (#selector(updateCallDeclinedTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateCallDeclinedTimer() {
        
        timerCallDeclined?.invalidate()
        self.providerDelegate.RejectSessionSub(callStatus: enumCallStatus.unanswered.rawValue)
        NotificationCenter.default.post(name: .rejectCall, object:nil)
    }
    
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false,temp:callingStruct, completion: ((NSError?) -> Void)? = nil) {
        
        self.providerDelegate.reportIncomingCall(uuid: uuid, callername: handle, hasVideo: hasVideo,temp:temp) { (err) in
        }
    }
}
