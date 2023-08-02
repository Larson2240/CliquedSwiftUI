//
//  Constants.swift
//  Bubbles
//
//  Created by C100-107 on 10/04/20.
//  Copyright © 2020 C100-107. All rights reserved.
//
// MARK: Description - This is a constant file which is store all the label's title, button's title, placeholder's string, screen's title, Font's and Colors at one file.

import UIKit


//MARK:- Classes
struct Constants_Message1 {
    
    var Chat_section_new_matches = "Chat_section_new_matches".localized()
    var Chat_section_messages = "Chat_section_messages".localized()
    var title_textview_placeholder = "title_textview_placeholder".localized()
    var title_textview_validation = "title_textview_validation".localized()
    var label_noActivityFound = "label_noActivityFound".localized()
    var user_create_activity_validation = "user_create_activity_validation".localized()
    var activity_category_placeholder = "activity_category_placeholder".localized()
    var activity_title_max_limit = "activity_title_max_limit".localized()
    var activity_description_max_limit = "activity_description_max_limit".localized()
    
    var activity_title_validation = "activity_title_validation".localized()
    var activity_description_validation = "activity_description_validation".localized()
    var activity_date_validation = "activity_date_validation".localized()
    var activity_category_validation = "activity_category_validation".localized()
    var activity_media_validation = "activity_media_validation".localized()
    var activity_address_validation = "activity_address_validation".localized()
    var activity_id_validation = "activity_id_validation".localized()
    var user_id_validation = "user_id_validation".localized()
//    var title_discover_activity = "title_discover_activity".localized()
    
    var alert_title_warning = "alert_title_warning".localized()
    var alert_doNotHaveCamera = "alert_doNotHaveCamera".localized()
    var title_ok = "title_ok".localized()
    var alert_title_setting = "alert_title_setting".localized()
    var Chat_Recording_Failed = "Chat_Recording_Failed".localized()
    var record_audio_continue = "record_audio_continue".localized()
    var record_audio_send = "record_audio_send".localized()
    var discard_title = "discard_title".localized()
    var send_title = "send_title".localized()
    var open_setting_title = "open_setting_title".localized()
    var cancel_title = "cancel_title".localized()
    var open_settin_in_device_text = "open_settin_in_device_text".localized()
    var button_title_unblock = "button_title_unblock".localized()
    var title_blocked_users = "title_blocked_users".localized()
    var alert_title_unblock_user = "alert_title_unblock_user".localized()
    var counter_user_id_validation = "counter_user_id_validation".localized()
    var search_title = "search_title".localized()
    var record_audio_hold = "record_audio_hold".localized()
    var title_email_settings = "title_email_settings".localized()
    var title_email_verification = "title_email_verification".localized()
    var title_email_sub_text = "title_email_sub_text".localized()
    var title_didnot_receiver_otp = "title_didnot_receiver_otp".localized()
    var btn_title_resend_otp = "btn_title_resend_otp".localized()
    var btn_verify = "btn_verify".localized()
    var label_Old_password = "label_Old_password".localized()
    var label_new_password = "label_new_password".localized()
    var placeholder_Old_password = "placeholder_Old_password".localized()
    var placeholder_New_password = "placeholder_New_password".localized()
    var title_email_notification = "title_email_notification".localized()
    var title_push_notification = "title_push_notification".localized()
    var title_delete_account = "title_delete_account".localized()
    var btn_delete = "btn_delete".localized()
    
    //MARK: Validation Message
    var validMsg_old_emailId = "validMsg_old_emailId".localized()
    var validMsg_otp_emailId = "validMsg_otp_emailId".localized()
    var validMsg_old_password = "validMsg_old_password".localized()
    var validMsg_new_password = "validMsg_new_password".localized()
    var title_change_language = "title_change_language".localized()
    
    var title_english = "title_english".localized()
    var title_french  = "title_french".localized()
    var title_german = "title_german".localized()
    var title_italian = "title_italian".localized()
    var title_select_language = "title_select_language".localized()
    

    //MARK: Remaining Text
    var activity_wrongSelectDate_validation = "In order to add activity for more than 30 days please subscribe to our plans & enjoy other benefits as well."
    var title_discover_activity = "Start Discovering"
    var alert_media_setting_message = "Would like to access the photos to update profile picture and you can do things like take and share photos, recorded videos and other special features of app."
    
    //MARK: Remaining
    var title_report_now = "title_report_now".localized()
    var btn_yes = "btn_yes".localized()
    var title_alert_for_block_by_user_chat = "title_alert_for_block_by_user_chat".localized()
    var title_alert_for_block_by_admin_chat = "title_alert_for_block_by_admin_chat".localized()
    var title_alert_for_deleted_user = "title_alert_for_deleted_user".localized()
    
    var title_today_text = "title_today_text".localized()
    var title_yesterday_text = "title_yesterday_text".localized()
    var title_online_text = "title_online_text".localized()
    var title_last_seen_text = "title_last_seen_text".localized()
    
    var title_connecting_text = "title_connecting_text".localized()
    var title_chat_no_data_text = "title_chat_no_data_text".localized()
    var title_camera_permission_text = "title_camera_permission_text".localized()
    var title_user_who_liked_me_text = "title_user_who_liked_me_text".localized()
    
    var title_login_detected = "title_login_detected".localized()
    var title_blocked_by_sender = "title_blocked_by_sender".localized()
    var title_active_text = "title_active_text".localized()
    var title_ago_text = "title_ago_text".localized()
    var title_hr_text = "title_hr_text".localized()
    var title_min_text = "title_min_text".localized()
    var title_hrs_text = "title_hrs_text".localized()
    var title_mins_text = "title_mins_text".localized()
    var title_sec_text = "title_sec_text".localized()
    
    var validation_media_upload = "validation_media_upload".localized()
}

var Constants_Message = Constants_Message1()

enum enumMessageType: String {
    case text = "0"
    case image = "1"
    case video = "2"
    case audio = "3"
    case groupCreated = "4"
    case renamed = "5"
    case groupPicture = "6"
    case memberAdded = "7"
    case memberRemoved = "8"
    case memberLeft = "9"
    case videoCall = "10"
    case audioCall = "11"
}

enum enumCallStatus: String {
    case none = "0"
    case unanswered = "1"
    case calling = "2"
    case received = "3"
    case cut = "4"
    case ended = "5"
    case failed = "6"
    case rejected = "7"
    case unknown = "8"
}

enum enumMessageMediaType: String {
    case image = "0"
    case video = "1"
    case audio = "2"
}

enum enumMessageStatus: String {
    case notDelivered = "0"
    case delivered = "1"
    case read = "2"
}

enum enumNotificationType: String {
    case newMatches = "0"
    case message = "1"
    case userLikesActivity = "2"
    case CreatorAcceptActivityRequest = "3"
    case CreatorRejectActivityRequest = "4"
}

struct callingStruct {
    
    var room_sid = String()
    var room_Name = String()
    var sender_access_token = String()
    var callId = String()
    var privateRoom = String()
    var isHost = String()    
    var uuid = String()    
    var is_audio_call = String()
    var sender_name = String()
    var sender_profile = String()
}

class Calling {
    
    static var room_sid = ""
    static var room_Name = String()
    static var sender_access_token = ""
    static var receiverId = Constants.loggedInUser?.id?.description
    static var call_id = "0"
    static var call_start_time = ""
    static var call_end_time = ""
    static var receiver_name = ""
//    static var receiver_name = [String]()
    static var uuid = UUID().description
    static var is_privateRoom = "0"
    static var is_host = ""
    static var is_audio_call = "1"
    static var call_status = "0"
    static var user_count = 0
    static var loginUserId = Constants.loggedInUser?.id
    static var firstName = Constants.loggedInUser?.name
    static var otherUserProfile = ""
}

enum Language1: String {
    
    case none = ""
    case en = "English"
    case fr = "French"
    case it = "Italian"
    case de = "German"
}

enum LanguageStrCode: String {
    
    case none = ""
    case en = "en"
    case fr = "fr"
    case it = "it"
    case de = "de"
}


var chatDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
let DATE_FORMAT = "MM/dd/yyyy"
let TIME_FORMAT = "hh:mm a"
let TIME_FORMAT_FULL = "HH:mm"
let CHAT_FORMAT = "MM/dd/yyyy hh:mm a"
let UTC_FORMAT = "yyyy-MM-dd HH:mm:ss"
let ACTIVITY_DATE_FORMAT = "dd/MM/yyyy"
let DATEPICKER_DATE_FORMAT = "dd-MM-yyyy"
let MEDIA_SIZE = 50 //Size in MB

//MARK:- User default keys?
struct USER_DEFAULT_KEYS {    
    static let VOIP_TOKEN = "voip_token"
    static let OLD_CALL_ID = "old_call_id"
    static let OLD_CALL_UUID = "old_call_uuid"
    static let CALLER_CALL_UUID = "caller_call_uuid"
    static let kUserLanguage = "userLanguage"
}

extension Notification.Name {   
    static let incomingCall = Notification.Name("incomingCall")
    static let startCall = Notification.Name("StartCall")
    static let endCall = Notification.Name("EndCall")
    static let unansweredCall = Notification.Name("UnansweredCall")
    static let rejectCall = Notification.Name("RejectCall")
    static let rejectedCall = Notification.Name("RejectedCall")
    static let updateName = Notification.Name("updateName")
    static let audioCallList = Notification.Name("audioCallList")
    static let connectCall = Notification.Name("ConnectCall")
    
    static let invalidTimer = Notification.Name("invalidTimer")
}
