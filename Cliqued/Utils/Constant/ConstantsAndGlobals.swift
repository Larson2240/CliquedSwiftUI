//
//  Constants.swift
//  Bubbles
//
//  Created by C100-107 on 10/04/20.
//  Copyright © 2020 C100-107. All rights reserved.
//
// MARK: Description - This is a constant file which is store all the label's title, button's title, placeholder's string, screen's title, Font's and Colors at one file.

import UIKit

let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
let APP_BUNDLE_IDENTIFIRE = "com.ios.Cliqued1"

let MaxPictureSelect = 6
let maxProgress = 9.0
let MaxActivitySelect = 1
let MaxChatMediaSelect = 1
var controllerName: UIViewController?

//MARK:- Classes
struct Constants_String {
    
    let googleSignInKey = "83629820882-im9cceg8ef4njeba15a4ce1u53hk0a3i.apps.googleusercontent.com"
    
    //Url for contact us
    let urlContactUsEn = "https://cliqued.app/en/contact/"
    let urlContactUsDe = "https://cliqued.app/kontakt/"
    let urlContactUsFr = "https://cliqued.app/fr/contact/"
    let urlContactUsIt = "https://cliqued.app/it/contattaci/"
    
    //Url for community guidelines
    let urlCommunityGuideEn = "https://cliqued.app/en/community-guidelines/"
    let urlCommunityGuideDe = "https://cliqued.app/community-richtlinien/"
    let urlCommunityGuideFr = "https://cliqued.app/fr/regles-de-la-communaute/"
    let urlCommunityGuideIt = "https://cliqued.app/it/regole-della-comunita/"
    
    //Url for safety center
    let urlSafetyTipsEn = "https://cliqued.app/en/safety-tips/"
    let urlSafetyTipsDe = "https://cliqued.app/sicherheitstipps/"
    let urlSafetyTipsFr = "https://cliqued.app/fr/conseils-de-securite/"
    let urlSafetyTipsIt = "https://cliqued.app/it/suggerimenti-sulla-sicurezza/"
    
    //Url for cookie policy
    let urlCookiePolicyEn = "https://cliqued.app/en/cookie-policy/"
    let urlCookiePolicyDe = "https://cliqued.app/cookie-richtlinie/"
    let urlCookiePolicyFr = "https://cliqued.app/fr/politique-relative-aux-cookies/"
    let urlCookiePolicyIt = "https://cliqued.app/it/informativa-sui-cookie/"
    
    //Url for privacy policy
    let urlPrivacyPolicyEn = "https://cliqued.app/en/privacy-policy/"
    let urlPrivacyPolicyDe = "https://cliqued.app/datenschutzrichtlinie/"
    let urlPrivacyPolicyFr = "https://cliqued.app/fr/politique-de-confidentialite/"
    let urlPrivacyPolicyIt = "https://cliqued.app/it/informativa-sulla-privacy/"
    
    //Url for terms condition
    let urlTermsConditionEn = "https://cliqued.app/en/terms-and-conditions/"
    let urlTermsConditionDe = "https://cliqued.app/fr/conditions-dutilisation/"
    let urlTermsConditionFr = "https://cliqued.app/fr/conditions-dutilisation/"
    let urlTermsConditionIt = "https://cliqued.app/it/termini-e-condizioni/"
    
    
    
    //MARK: Placeholder
    var placeholder_email = "placeholder_email".localized()
    var placeholder_password = "placeholder_password".localized()
    var placeholder_repeatPassword = "placeholder_repeatPassword".localized()
    var placeholder_userName = "placeholder_userName".localized()
    var placeholder_name = "placeholder_name".localized()
    var placeholder_shortTitle = "placeholder_shortTitle".localized()
    var placeholder_height = "placeholder_height".localized()
    var placeholder_activityDescription = "placeholder_activityDescription".localized()
    
    //MARK: Button Title
    var btn_signUp = "btn_signUp".localized()
    var btn_logIn = "btn_logIn".localized()
    var btn_forgotPassword = "btn_forgotPassword".localized()
    var btn_rememberMe = "btn_rememberMe".localized()
    var btn_continue = "btn_continue".localized()
    var btn_submit = "btn_submit".localized()
    var btn_save = "btn_save".localized()
    var btn_next = "btn_next".localized()
    var btn_done = "btn_done".localized()
    var btn_cancel = "btn_cancel".localized()
    var btn_logout = "btn_logout".localized()
    var btn_block = "btn_block".localized()
    var btn_saveProfile = "btn_saveProfile".localized()
    var btn_startExploring = "btn_startExploring".localized()
    var btn_messageNow = "btn_messageNow".localized()
    var btn_messageLater = "btn_messageLater".localized()
    var btn_completeProfile = "btn_completeProfile".localized()
    var btn_noThanks = "btn_noThanks".localized()
    
    var btn_dontHaveAccount = "btn_dontHaveAccount".localized()
    var btn_alreadyHaveAccount = "btn_alreadyHaveAccount".localized()
    
    var btn_male = "btn_male".localized()
    var btn_female = "btn_female".localized()
    var btn_romance = "btn_romance".localized()
    var btn_friendship = "btn_friendship".localized()
    var btn_women = "btn_women".localized()
    var btn_men = "btn_men".localized()
    var btn_enableNotification = "btn_enableNotification".localized()
    var btn_disableNotification = "btn_disableNotification".localized()
    var btn_goToCurrentLocation = "btn_goToCurrentLocation".localized()
    var btn_reportUser = "btn_reportUser".localized()
    var btn_blockUser = "btn_blockUser".localized()
    var btn_addActivity = "btn_addActivity".localized()
    var btn_startDiscovering = "btn_startDiscovering".localized()
    var btn_editProfile = "btn_editProfile".localized()
    var btn_changeEmail = "btn_changeEmail".localized()
    var btn_changePassword = "btn_changePassword".localized()
    var btn_skip = "btn_skip".localized()
    var btn_disable = "btn_disable".localized()
    var btn_send = "btn_send".localized()
    
    //MARK: Screen Title
    var screenTitle_signUp = "screenTitle_signUp".localized()
    var screenTitle_forgotPwd = "screenTitle_forgotPwd".localized()
    var screenTitle_welcome = "screenTitle_welcome".localized()
    var screenTitle_activities = "screenTitle_activities".localized()
    var screenTitle_createActivity = "screenTitle_createActivity".localized()
    var screenTitle_editActivity = "screenTitle_editActivity".localized()
    var screenTitle_chat = "screenTitle_chat".localized()
    var screenTitle_editProfile = "screenTitle_editProfile".localized()
    var screenTitle_connectedAccount = "screenTitle_connectedAccount".localized()
    var screenTitle_emailSettings = "screenTitle_emailSettings".localized()
    var screenTitle_passwordSettings = "screenTitle_passwordSettings".localized()
    
    var screenTitle_name = "screenTitle_name".localized()
    var screenTitle_age = "screenTitle_age".localized()
    var screenTitle_gender = "screenTitle_gender".localized()
    var screenTitle_relationship = "screenTitle_relationship".localized()
    var screenTitle_pickActivity = "screenTitle_pickActivity".localized()
    var screenTitle_pickSubactivity = "screenTitle_pickSubactivity".localized()
    var screenTitle_selectPictures = "screenTitle_selectPictures".localized()
    var screenTitle_setYourLocation = "screenTitle_setYourLocation".localized()
    var screenTitle_notification = "screenTitle_notification".localized()
    var screenTitle_settings = "screenTitle_settings".localized()
    
    //MARK: descriptions (for labels)
    var label_appName = "label_appName".localized()
    var label_noDataFound = "label_noDataFound".localized()
    var label_appWelcomeTitle = "label_appWelcomeTitle".localized()
    var label_appWelcomeSubTitle = "label_appWelcomeSubTitle".localized()
    var label_email = "label_email".localized()
    var label_password = "label_password".localized()
    var label_repeatPassword = "label_repeatPassword".localized()
    var label_or = "label_or".localized()
    var label_tabHome = "label_tabHome".localized()
    var label_tabActivities = "label_tabActivities".localized()
    var label_tabChat = "label_tabChat".localized()
    var label_tabProfile = "label_tabProfile".localized()
    var label_with = "label_with".localized()
    var label_name = "label_name".localized()
    var label_aboutMe = "label_aboutMe".localized()
    var label_favoriteActivities = "label_favoriteActivities".localized()
    var label_myFavoriteActivities = "label_myFavoriteActivities".localized()
    var label_apple = "label_apple".localized()
    var label_facebook = "label_facebook".localized()
    var label_Google = "label_Google".localized()
    
    var label_lookingFor = "label_lookingFor".localized()
    var label_location = "label_location".localized()
    var label_height = "label_height".localized()
    var label_kids = "label_kids".localized()
    var label_smoking = "label_smoking".localized()
    var label_reportUser = "label_reportUser".localized()
    var label_reportReasonTitle = "label_reportReasonTitle".localized()
    var label_reportThankYouTitle = "label_reportThankYouTitle".localized()
    var label_matchScreenText = "label_matchScreenText".localized()
    var label_yourActivities = "label_yourActivities".localized()
    var label_otherUserActivities = "label_otherUserActivities".localized()
    var label_activityCategory = "label_activityCategory".localized()
    var label_shortTitle = "label_shortTitle".localized()
    var label_photo = "label_photo".localized()
    var label_date = "label_date".localized()
    var label_description = "label_description".localized()
    var label_photoDescription = "label_photoDescription".localized()
    var label_distancePreference = "label_distancePreference".localized()
    var label_agePreference = "label_agePreference".localized()
    var label_emailSentMessage = "label_emailSentMessage".localized()
    var label_notificationDisableTitle = "label_notificationDisableTitle".localized()
    var label_notificationDisableMessage = "label_notificationDisableMessage".localized()
    var label_logoutAlertMsg = "label_logoutAlertMsg".localized()
    var label_blockAlertMsg = "label_blockAlertMsg".localized()
    //    var label_deleteAlertMsg = "label_deleteAlertMsg".localized()
    
    //Subscription Plan Benefits Text
    var label_planBenefitText1 = "label_planBenefitText1".localized()
    var label_planBenefitText2 = "label_planBenefitText2".localized()
    var label_planBenefitText3 = "label_planBenefitText3".localized()
    var label_planBenefitText4 = "label_planBenefitText4".localized()
    var label_planBenefitText5 = "label_planBenefitText5".localized()
    var label_planBenefitText6 = "label_planBenefitText6".localized()
    
    //Settings Section Title's
    var labelSettingSectionTitle_accountSetting = "labelSettingSectionTitle_accountSetting".localized()
    var labelSettingSectionTitle_subscription = "labelSettingSectionTitle_subscription".localized()
    var labelSettingSectionTitle_connections = "labelSettingSectionTitle_connections".localized()
    var labelSettingSectionTitle_activeStatus = "labelSettingSectionTitle_activeStatus".localized()
    var labelSettingSectionTitle_notifications = "labelSettingSectionTitle_notifications".localized()
    var labelSettingSectionTitle_otherSettings = "labelSettingSectionTitle_otherSettings".localized()
    var labelSettingSectionTitle_contactUs = "labelSettingSectionTitle_contactUs".localized()
    var labelSettingSectionTitle_community = "labelSettingSectionTitle_community".localized()
    var labelSettingSectionTitle_privacy = "labelSettingSectionTitle_privacy".localized()
    var labelSettingSectionTitle_legal = "labelSettingSectionTitle_legal".localized()
    
    //Settings Row Title's
    var labelSettingRowTitle_email = "labelSettingRowTitle_email".localized()
    var labelSettingRowTitle_password = "labelSettingRowTitle_password".localized()
    var labelSettingRowTitle_connetedAccounts = "labelSettingRowTitle_connetedAccounts".localized()
    var labelSettingRowTitle_inAppPurchase = "labelSettingRowTitle_inAppPurchase".localized()
    var labelSettingRowTitle_blockedContacts = "labelSettingRowTitle_blockedContacts".localized()
    var labelSettingRowTitle_onlineNow = "labelSettingRowTitle_onlineNow".localized()
    var labelSettingRowTitle_lastSeenStatus = "labelSettingRowTitle_lastSeenStatus".localized()
    var labelSettingRowTitle_emailNotifications = "labelSettingRowTitle_emailNotifications".localized()
    var labelSettingRowTitle_pushNotifications = "labelSettingRowTitle_pushNotifications".localized()
    var labelSettingRowTitle_restorePurchase = "labelSettingRowTitle_restorePurchase".localized()
    var labelSettingRowTitle_inviteFriends = "labelSettingRowTitle_inviteFriends".localized()
    var labelSettingRowTitle_helpAndSupport = "labelSettingRowTitle_helpAndSupport".localized()
    var labelSettingRowTitle_communityGuidelines = "labelSettingRowTitle_communityGuidelines".localized()
    var labelSettingRowTitle_safetyTips = "labelSettingRowTitle_safetyTips".localized()
    var labelSettingRowTitle_safetyCenter = "labelSettingRowTitle_safetyCenter".localized()
    var labelSettingRowTitle_cookiePolicy = "labelSettingRowTitle_cookiePolicy".localized()
    var labelSettingRowTitle_privacyPolicy = "labelSettingRowTitle_privacyPolicy".localized()
    var labelSettingRowTitle_privacyPreference = "labelSettingRowTitle_privacyPreference".localized()
    var labelSettingRowTitle_termsOfService = "labelSettingRowTitle_termsOfService".localized()
    var labelSettingRowTitle_licenses = "labelSettingRowTitle_licenses".localized()
    
    var label_termsMessage = "label_termsMessage".localized()
    var label_ForgotPwdScreenDescription = "label_ForgotPwdScreenDescription".localized()
    var label_nameScreenTitle = "label_nameScreenTitle".localized()
    var label_nameScreenSubTitle = "label_nameScreenSubTitle".localized()
    var label_ageScreenTitleBeforName = "label_ageScreenTitleBeforName".localized()
    var label_ageScreenTitleAfterName = "label_ageScreenTitleAfterName".localized()
    var label_ageScreenSubTitle = "label_ageScreenSubTitle".localized()
    var label_genderScreenTitle = "label_genderScreenTitle".localized()
    var label_genderScreenSubTitle = "label_genderScreenSubTitle".localized()
    var label_relationshipScreenTitle = "label_relationshipScreenTitle".localized()
    var label_relationshipScreenSubTitle = "label_relationshipScreenSubTitle".localized()
    var label_pickActivityScreenTitle = "label_pickActivityScreenTitle".localized()
    var label_pickActivityScreenSubTitle = "label_pickActivityScreenSubTitle".localized()
    var label_pickSubActivityScreenTitle = "label_pickSubActivityScreenTitle".localized()
    var label_pickSubActivityScreenSubTitle = "label_pickSubActivityScreenSubTitle".localized()
    var label_selectPictureScreenTitle = "label_selectPictureScreenTitle".localized()
    var label_selectPictureScreenSubTitle = "label_selectPictureScreenSubTitle".localized()
    var label_setLocationScreenSubTitle = "label_setLocationScreenSubTitle".localized()
    var label_setLocationScreenDescription = "label_setLocationScreenDescription".localized()
    var label_notificationScreenSubTitle = "label_notificationScreenSubTitle".localized()
    var label_startExploringSubTitle = "label_startExploringSubTitle".localized()
    var label_reportUserDescriptionFirst = "label_reportUserDescriptionFirst".localized()
    var label_reportUserDescriptionSecond = "label_reportUserDescriptionSecond".localized()
    var label_reportThankYouDescription = "label_reportThankYouDescription".localized()
    var label_LogoutMsg = "label_LogoutMsg".localized()
    var label_connectedAccountDescription = "label_connectedAccountDescription".localized()
    
    //MARK: Validation Message
    var validMsg_emailId = "validMsg_emailId".localized()
    var validMsg_invalidEmail = "validMsg_invalidEmail".localized()
    var validMsg_password = "validMsg_password".localized()
    var validMsg_repeatPassword = "validMsg_repeatPassword".localized()
    var validMsg_passwordNotMatche = "validMsg_passwordNotMatche".localized()
    var validMsg_invalidPassword = "validMsg_invalidPassword".localized()
    var validMsg_passwordLengthCount = "validMsg_passwordLengthCount".localized()
    var validMsg_name = "validMsg_name".localized()
    var validMsg_validName = "validMsg_validName".localized()
    var validMsg_emailNotVerified = "validMsg_emailNotVerified".localized()
    var validMsg_age = "validMsg_age".localized()
    var validMsg_gender = "validMsg_gender".localized()
    var validMsg_pickActivity = "validMsg_pickActivity".localized()
    var validMsg_pickSubActivity = "validMsg_pickSubActivity".localized()
    var validMsg_relationship = "validMsg_relationship".localized()
    var validMsg_selectPicture = "validMsg_selectPicture".localized()
    var validMsg_selectImage = "validMsg_selectImage".localized()
    var validMsg_faceDetection = "validMsg_faceDetection".localized()
    var validMsg_wrongPasswordAttempt = "validMsg_wrongPasswordAttempt".localized()
    var validMsg_profileSetup = "validMsg_profileSetup".localized()
    var validMsg_blockedAccount = "validMsg_blockedAccount".localized()
    var validMsg_reportReason = "validMsg_reportReason".localized()
    
    //MARK: Alerts Messages
    var alertCancelled = "alertCancelled".localized()
    var alertAuthorizationFailed = "alertAuthorizationFailed".localized()
    var alertInvalidResponse = "alertInvalidResponse".localized()
    var alertAuthorizationNotHandeled = "alertAuthorizationNotHandeled".localized()
    var alertUnknownResponseFromAppleAuth = "alertUnknownResponseFromAppleAuth".localized()
    var alertUnknownErrorCode = "alertUnknownErrorCode".localized()
    var warningIOSVersion = "warningIOSVersion".localized()
    var alert_InternetConnectivity = "alert_InternetConnectivity".localized()
    
    //MARK: Remaining Text
    var label_deleteAlertMsg = "label_deleteAlertMsg".localized()
    var label_subscriptionTerms = "label_subscriptionTerms".localized()
    var label_monthTitle = "label_monthTitle".localized()
    var label_bestValueTitle = "label_bestValueTitle".localized()
    var validMsg_profileIncompleteMsg = "validMsg_profileIncompleteMsg".localized()
    var label_noPlanAvailable = "label_noPlanAvailable".localized()
    var label_titleYes = "label_titleYes".localized()
    var label_titleNo = "label_titleNo".localized()
    var validMsg_alredyHaveEmailId = "validMsg_alredyHaveEmailId".localized()
    var label_newEmailTitle = "label_newEmailTitle".localized()
    var btn_unsubscribe = "btn_unsubscribe".localized()
    var btn_subscribe = "btn_subscribe".localized()
    var label_activityMatchScreenTitle = "label_activityMatchScreenTitle".localized()
    
    //    var btn_viewPlan = "btn_viewPlan".localized()
    //    var label_likes = "label_likes".localized()
    //    var btn_settings = "btn_settings".localized()
    //    var label_locationPermissionAlertMsg = "label_locationPermissionAlertMsg".localized()
    //    var label_locationAlertTitle = "label_locationAlertTitle".localized()
    
    var btn_viewPlan = "View plan"
    var label_likes = "Likes"
    var btn_settings = "Settings"
    var label_locationPermissionAlertMsg = "Would like to access your location to show the profiles and relavent matches users which is near by you."
    var label_locationAlertTitle = "Permission Denied"
    var validMsg_validHeight = "Please enter a valid height"
    var alertMsg_noAdsAvailable = "No ads available."
    var alertMsg_validHeight = "Please check your height again"
    var label_heightInCm = "(cm)"
    var label_kmAway = "km away"
    var validMsg_validAddress = "Failed to load location. Please try again by dragging pin or click on the current location."
    
    //    var label_activityScreenPlaceholder = "There are no more activities at the moment, stay connected."
    //    var label_interestedActivityScreenPlaceholder = "There are no more interested peoples on your activity."
    //    var label_profileSwipeCardScreenPlaceholder = "There are no more users at the moment, stay connected."
    //    var label_profileSwipeViewFinish = "Your daily limit for profile is reached. Please upgrade your plan to view more profile or try again tomorrow."
    //    var label_activitySwipeViewFinish = "Your daily limit for activities is reached. Please upgrade your plan to view more activities or try again tomorrow."
    //    var label_addActivityPlaceholder = "Recently you have no activity. To add your activity tap on add activity button."
    //    var label_discoveryActivityPlaceholder = "Recently no other user's activities are available."
    
    var label_activityScreenPlaceholder = "There are no more activities at the moment, stay connected."
    var label_interestedActivityScreenPlaceholder = "There are no more interested peoples on your activity."
    var label_profileSwipeCardScreenPlaceholder = "There are no more users at the moment, stay connected."
    var label_profileSwipeViewFinish = "Your daily limit for profile is reached. Please upgrade your plan to view more profile or try again tomorrow."
    var label_activitySwipeViewFinish = "Your daily limit for activities is reached. Please upgrade your plan to view more activities or try again tomorrow."
    var label_addActivityPlaceholder = "Recently you have no activity. To add your activity tap on add activity button."
    var label_discoveryActivityPlaceholder = "Recently no other user's activities are available."
    
    
    //MARK: Color
    var color_themeColor = UIColor(named: "ThemeColor")!
    var color_black = UIColor(named: "BlackColor")!
    var color_white = UIColor(named: "WhiteColor")!
    var color_lightGrey = UIColor(named: "LightGreyColor")!
    var color_DarkGrey = UIColor(named: "DarkGreyColor")!
    var color_MediumGrey = UIColor(named: "MediumGreyColor")!
    var color_NavigationBarText = UIColor(named: "NavigationBarTextColor")!
    var color_GreenSelectedBkg = UIColor(named: "GreenSelectedBkg")!
    var color_GreyUnselectedBkg = UIColor(named: "GreyUnselectedBkg")!
    var color_AppBackgroundColor = UIColor(named: "AppBackgroundColor")!
    var color_message_time = UIColor(named: "ChatColor")
    var color_chat_name = UIColor(named: "chatNameColor")
    var color_sender_text_msg = UIColor(named: "senderMsgTextColor")
    
    //MARK: Check user is loggedIn
    var isUserLoggedIn : Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKey().isLoggedIn)
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey().isLoggedIn)
        }
    }
    
    //MARK: Save user details in UserDefaults
    var loggedInUser: User? {
        get {
            UserDefaults.standard.getCustom(User.self, forKey: UserDefaultKey().userData)
        }
        set {
            UserDefaults.standard.setCustom(newValue, forKey: UserDefaultKey().userData)
        }
    }
    func saveUserInfoAndProceed(user: User){
        UserDefaults.standard.setCustom(user, forKey: UserDefaultKey().userData)
        UserDefaults.standard.set(user.guid, forKey: kUserGUID)
    }
    
    //MARK: Save preference data in UserDefaults
    var getPreferenceData: [PreferenceClass]? {
        get {
            UserDefaults.standard.getCustomArr(PreferenceClass.self, forKey: UserDefaultKey().preferenceData)
        }
        set{
            UserDefaults.standard.setCustomArr(newValue ?? [], forKey: UserDefaultKey().preferenceData)
        }
    }
    func savePreferenceData(preferene: [PreferenceClass]){
        UserDefaults.standard.setCustomArr(preferene, forKey: UserDefaultKey().preferenceData)
    }
}

var Constants = Constants_String()

class GlobalVariables{
    static var appDelegate = UIApplication.shared.delegate as? AppDelegate
}

class CustomFont {
    static func THEME_FONT_Bold(_ Size: CGFloat) -> UIFont? {
        UIFont(name: "Rationell-Bold", size: Size)
    }
    
    static func THEME_FONT_Black(_ Size: CGFloat) -> UIFont? {
        UIFont(name: "Rationell-Black", size: Size)
    }
    
    static func THEME_FONT_Book(_ Size: CGFloat) -> UIFont? {
        UIFont(name: "Rationell-Book", size: Size)
    }
    
    static func THEME_FONT_Medium(_ Size: CGFloat) -> UIFont? {
        UIFont(name: "Rationell-Medium", size: Size)
    }
    
    static func THEME_FONT_Regular(_ Size: CGFloat) -> UIFont? {
        UIFont(name: "Rationell-Regular", size: Size)
    }
    
    static func THEME_FONT_Light(_ Size: CGFloat) -> UIFont? {
        UIFont(name: "Rationell-Light", size: Size)
    }
    
    static let bold = "Rationell-Bold"
    static let black = "Rationell-Black"
    static let book = "Rationell-Book"
    static let medium = "Rationell-Medium"
    static let regular = "Rationell-Regular"
    static let light = "Rationell-Light"
}

//MARK:----------------------------------------------------------------
//MARK: Check email validation
func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

//MARK:----------------------------------------------------------------
//MARK: Check password validation
func isPasswordHasNumberAndCharacter(password: String) -> Bool {
    //    let passRegEx = "^([a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
    let passRegEx = "^(?=.*[0-9])(?=.*[A-Z]).{8,}$"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
    return passwordTest.evaluate(with: password)
}

//MARK:----------------------------------------------------------------
//MARK: Check email validation
func isOnlyCharacter(text: String) -> Bool {
    let characterRegEx = "[a-zA-Z\\s]+"
    let characterPred = NSPredicate(format:"SELF MATCHES %@", characterRegEx)
    return characterPred.evaluate(with: text)
}

//MARK:----------------------------------------------------------------
//MARK: Get selected language name
func getLanguage() -> String {
    
    var strLanguage = LanguageStrCode.en.rawValue
    if let strCode = UserDefaults.standard.string(forKey: "language") {
        strLanguage = strCode
    } else if let strCode = UserDefaults.standard.string(forKey: "i18n_language") {
        strLanguage = strCode
    }
    
    UserDefaults.standard.set(strLanguage, forKey: "i18n_language")
    UserDefaults.standard.set(strLanguage, forKey: "language")
    UserDefaults.standard.synchronize()
    
    Constants = Constants_String()
    Constants_Message = Constants_Message1()
    return strLanguage
}
