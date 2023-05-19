//
//  WebService-Prefix.swift
//
//  Created by C196 on 25/03/20
//  Copyright (c) . All rights reserved.
//


import Foundation

//MARK: ------------------------------------------------------------------------
//MARK: Client Live Server
//
//let SERVER_URL                  = "http://clientapp.narola.online/pg/"
//let WEBSERVICE_PATH             = "\(SERVER_URL)cliqued/v1/Service.php?Service="

let SERVER_URL                  = "http://3.120.122.231/"
let WEBSERVICE_PATH             = "\(SERVER_URL)cliqued/WS/v1/Service.php?Service=" //Live
//let WEBSERVICE_PATH             = "\(SERVER_URL)cliqued/WS/stage_v1/Service.php?Service=" //Stage

let URLBaseThumb            = "\(SERVER_URL)cliqued/WS/v1/Utilities/thumb.php?"
let UrlProfileImage         = "\(SERVER_URL)cliqued/WS/Upload/User/"
let UrlChatMedia            = "\(SERVER_URL)cliqued/WS/Upload/Chat/"
let UrlUserActivity         = "\(SERVER_URL)cliqued/WS/Upload/User_Activity/"
let UrlActivityImage        = "\(SERVER_URL)cliqued/WS/Upload/Category/"
let UrlTutorialImage        = "\(SERVER_URL)cliqued/WS/Upload/Tutorial/"

let privacypolicyURL = ""
let termsAndConditionURL = ""

//MARK: ------------------------------------------------------------------------
//MARK: API Names
struct structApiName {
    //Refresh Token
    let RefreshToken                    = "\(WEBSERVICE_PATH)RefreshToken"
    
    //User
    let Login                           = "\(WEBSERVICE_PATH)login"
    let SocialLogin                     = "\(WEBSERVICE_PATH)socialLogin"
    let ForgotPwd                       = "\(WEBSERVICE_PATH)forgotPassword"
    let Logout                          = "\(WEBSERVICE_PATH)logout"
    let SignUp                          = "\(WEBSERVICE_PATH)register"
    let GetUserDetails                  = "\(WEBSERVICE_PATH)getUserDetails"
    
    let GetUserLikesList                = "\(WEBSERVICE_PATH)GetUserListForLikes"
    
    let GetAllActivityList              = "\(WEBSERVICE_PATH)GetAllActivityList_v3"
    let AddUserActivity                 = "\(WEBSERVICE_PATH)addUserActivity"
    let GetActivityDetails              = "\(WEBSERVICE_PATH)getActivityDetails"
    let GetActivityInterestedPeople     = "\(WEBSERVICE_PATH)GetUserActivityInterestedPeople"
    let MarkUserActivityAsInterested    = "\(WEBSERVICE_PATH)markUserActivityAsInterested"
    let MarkActivityInterestForUser     = "\(WEBSERVICE_PATH)markActivityInterestForUser"
    let EditActivity                    = "\(WEBSERVICE_PATH)editActivity"
    let GetUserActivity                 = "\(WEBSERVICE_PATH)GetUserActivity_v3"
    //    let UpdateProfile                   = "\(WEBSERVICE_PATH)updateProfile"
    let UpdateProfile                   = "\(WEBSERVICE_PATH)updateProfile_v2"
    
    let UploadChatMediaUrl              = "\(WEBSERVICE_PATH)UploadChatMedia"
    let GetBlockedUserList              = "\(WEBSERVICE_PATH)getBlockedUserList"
    let MarkUserAsBlock                 = "\(WEBSERVICE_PATH)markUserAsBlock"
    let GetTwilioAccessToken            = "\(WEBSERVICE_PATH)getAccesssToken"
    let SentOTPForEmailID            = "\(WEBSERVICE_PATH)sentOTPForEmailID"
    let VerifyOTPForEmailID            = "\(WEBSERVICE_PATH)verifyOTPForEmailID"
    let ChangePassword            = "\(WEBSERVICE_PATH)changePassword"
    let UpdateNotificationSettings            = "\(WEBSERVICE_PATH)updateNotificationSettings"
    let DeleteAccount                   = "\(WEBSERVICE_PATH)deleteAccount"
    let CheckCallStatusOfReceiver            = "\(WEBSERVICE_PATH)CheckCallStatusOfReceiver"
    
    //Master API
    let GetMasterPreferenceAPI          = "\(WEBSERVICE_PATH)getMasterPreferenceAPI"
    //    let GetActivityCategory             = "\(WEBSERVICE_PATH)getActivityCategory"
    let GetActivityCategory             = "\(WEBSERVICE_PATH)GetActivityCategory_v2"
    
    //Home API's
    let GetUserInterestedCategory       = "\(WEBSERVICE_PATH)getUserInterestedCategory"
    let GetUsersForActivity             = "\(WEBSERVICE_PATH)GetUsersForActivity_new_age_2"
    //    let SetUserFollowStatus             = "\(WEBSERVICE_PATH)SetUserFollowStatus"
    let SetUserFollowStatus             = "\(WEBSERVICE_PATH)SetUserFollowStatus_v2"
    let SendPushNotificationToMatchedUser             = "\(WEBSERVICE_PATH)sendPushNotificationToMatchedUser"
    let AddReportForUser                = "\(WEBSERVICE_PATH)addReportForUser"
    let BlcokUser                       = "\(WEBSERVICE_PATH)markUserAsBlock"
    
    //In-App Purchase
    let GetSubscriptionPlanList         = "\(WEBSERVICE_PATH)getMasterSubscriptionDetails"
    let addUserSubscriptionDetails      = "\(WEBSERVICE_PATH)addUserSubscriptionDetails"
    let UpdateNotificationToken      = "\(WEBSERVICE_PATH)updateNotificationToken"
}

var APIName = structApiName()

struct APIConstant {
    
    //SOCKET IO
    static let SOCKET_SERVER_PATH = "http://3.120.122.231:8085" // live
    //    static let SOCKET_SERVER_PATH = "http://3.120.122.231:8086" // dev
    //    static let SOCKET_SERVER_PATH = "http://192.168.100.132:8080"
    
    //MARK:- SOCKET API
    static let APISocketJoin_Socket = "join_socket"
    static let APISocketIdentifyStatusChnage = "status_change"
    static let APISocketForeground = "inForeground"
    static let APISocketBackground = "inBackground"
    static let APISocketFetchMessages = "Get_All_Messages"
    static let APISocketFetchOldMessages = "Get_Old_Messages"
    static let APISOCKETSendNewMessage  = "send_new_message"
    static let APISOCKETUpdateMessageStatus  = "update_message_status"
    static let APISOCKETUpdateMessageStatusToSender  = "update_message_status_to_sender"
    static let APISOCKETGetNewMessage = "New_Message_Received"
    static let APISocketFetchConversationMessages = "Get_Conversion_Messages"
    static let APISocketGetUserChatStatus = "get_user_chat_online_status"
    static let APISocketUserConnectionChanged = "user_Connection_changed"
    
    static let APISocketCreateRoomForVideoCall = "create_room_for_video_call"
    static let APISocketNewIncomingCall = "new_incoming_call"
    
    //    static let APISockerCreate_Call_Session = "create_video_call_session"
    static let APISockerCall_Init_Receivers = "call_init_receivers"
    //let APISocketUpdateCallStatusParticipants = "update_call_status_for_participants"
    static let APISocketUpdateCallStatusParticipants = "update_call_status"
    static let APICallStatusUpdate = "call_status_update"
    static let APIFetchVideocallParticipants = "fetch_videocall_participants"
    static let APICallDismissBySender = "call_dismiss_by_sender"
    
    static let APIUserSecurityToken = "user_security_token"
    static let APICheckUserSecurityToken = "check_user_security_token"
    
    static let APIUserBlockedEvent = "user_blocked_event"
    static let APIBlockedInChat = "blocked_in_chat"
    
}
