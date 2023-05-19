//
//  API-Params.swift
//  MyPassApp
//
//  Created by C211 on 03/04/21.
//

import UIKit

//MARK: --------------------------------------------------------------
//MARK: API Common Parameters
struct structApiParams {
    
    let isTestdata = "isTestData"
    
    let email = "email"
    let password = "password"
    let social_id = "social_id"
    let userID = "user_id"
    let loginType = "login_type"
    let activityCategoryId = "activity_category_id"
    let activitySubCategoryId = "activity_sub_category_id"
    let title = "title"
    let description = "description"
    let date = "date"
    let activity_media = "activity_media[]"
    let thumbnail = "thumbnail[]"
    let userDeletedImageId = "user_deleted_image_id"
    let userDeletedCategoryId = "user_deleted_category_id"
    let userDeletedSubCategoryId = "delete_user_selected_sub_category_id"
    let activity_address = "activity_address"
    let activity_sub_category = "activity_sub_category"
    let address = "address"
    let city = "city"
    let state = "state"
    let country = "country"
    let latitude = "latitude"
    let longitude = "longitude"
    let pincode = "pincode"
    let addressId = "address_id"
    let distancePrefOptionId = "distance_preference_option_id"
    let distancePrefId = "distance_preference_id"
    let activityId = "activity_id"
    let interestedUserId = "interested_user_id"
    let isFollow = "is_follow"
    let isOwnActivity = "is_own_activity"
    let notificationOptionId = "notification_option_id"
    let notificationPrefId = "notification_preference_id"
    let ownerId = "owner_id"
    let activityName = "activity_name"
    
    let name = "name"
    let birthdate = "birthdate"
    let gender = "gender"
    let preferenceId = "preference_id"
    let preferenceOptionId = "preference_option_id"
    let userPreferenceId = "user_preference_id"
    
    let about_me = "about_me"
    let height = "height"
    let kids_preference_id = "kids_preference_id"
    let kids_option_id = "kids_option_id"
    let smoking_preference_id = "smoking_preference_id"
    let smoking_option_id = "smoking_option_id"
    let activity_selection = "activity_selection"
    let user_address = "user_address"
    let age_pref = "age_pref"
    let distance_pref = "distance_pref"
    let looking_for = "looking_for"
    let looking_for_deleted_id = "looking_for_deleted_id"
    let user_profile_image = "user_profile_image[]"
    let profile_setup_type = "profile_setup_type"
    let last_seen = "last_seen"
    let is_online = "is_online"
    let isActivity = "is_activity"

    let senderId = "sender_id"
    let receiverId = "receiver_id"
    let chatMedia = "chat_media[]"
    
    let counterUserId = "counter_user_id"
    let blockType = "block_type"
    let isBlock = "is_block"

    let notification_status = "notification_status"
    
    let ageStartId = "age_start_id"
    let ageStartPrefId = "age_start_pref_id"
    let ageEndId = "age_end_id"
    let ageEndPrefId = "age_end_pref_id"
    
    let reportedUserId = "reported_user_id"
    let reportReasonId = "report_reason_id"
    
    let offset = "offset"
    let room_id = "room_id"
    let newEmail = "new_email"
    let optCode = "otp_code"
    
    let oldPassword = "oldPassword"
    let newPassword = "newPassword"
    
    let subscriptionId = "subscription_id"
    let transactionId = "transaction_id"
    let amount = "amount"
    let transactionStartDate = "transaction_start_date"
    let transactionEndDate = "transaction_end_date"
    let isActive = "is_active"
    
    let deviceType = "Devicetype"
    let deviceToken = "Devicetoken"
    let voipToken = "voip_token"
    let isVideo = "is_video"
    let isPushEnabled = "is_pushEnabled"
    let userIds = "user_ids"
}
var APIParams = structApiParams()

//MARK: --------------------------------------------------------------
//MARK: API Common Parameters
struct structLoginType {
    let NORMAL = "0"
    let FACEBOOK = "1"
    let GOOGLE = "2"
    let APPLE = "3"
}
var LoginType = structLoginType()

//MARK: --------------------------------------------------------------
//MARK: API Common Parameters
struct structProfileSetupType {
    let none = "0"
    let name = "1"
    let birthdate = "2"
    let gender = "3"
    let relationship = "4"
    let category = "5"
    let sub_category = "6"
    let profile_images = "7"
    let location = "8"
    let notification_enable = "9"
    let completed = "10"
}
var ProfileSetupType = structProfileSetupType()

//MARK: --------------------------------------------------------------
//MARK: Preference Type Id's
struct structPreferenceTypeIds {
    let looking_for = "0"
    let romance = "1"
    let friendship = "2"
    let kids = "3"
    let smoking = "4"
    let distance = "5"
    let age = "6"
    let age_start = "7"
    let age_end = "8"
    let notification_enable = "9"
    let email_notification = "10"
    let push_notification = "11"
    let new_matches = "12"
    let messages = "13"
    let promotions = "14"
}
var PreferenceTypeIds = structPreferenceTypeIds()

struct structPreferenceOptionIds {
    let men = "0"
    let women = "1"
    let yes = "2"
    let no = "3"
    let other = "4"
}
var PreferenceOptionIds = structPreferenceOptionIds()

//MARK: --------------------------------------------------------------
//MARK: Gender Type Id's
struct structGenderTypeIds {
    let Men = "0"
    let Women = "1"
}
var GenderTypeIds = structGenderTypeIds()

//MARK: --------------------------------------------------------------
//MARK: Notification Type Id's
struct structNotificationPermissionTypeIds {
    let Yes = "2"
    let No = "3"
}
var NotificationPermissionTypeIds = structNotificationPermissionTypeIds()

//MARK: --------------------------------------------------------------
//MARK: Meetup Type
struct structIsMeetupIds {
    let Matched = 1
    let NotMatched = 0
}
var isMeetup = structIsMeetupIds()

//MARK: --------------------------------------------------------------
//MARK: IsPremium Type
struct structIsPremium {
    let Premium = "1"
    let NotPremium = "0"
}
var isPremium = structIsPremium()

//MARK: --------------------------------------------------------------
//MARK: Block Type
struct structBlock {
    let Block = "1"
    let UnBlock = "0"
}
var isBlock = structBlock()

//MARK: --------------------------------------------------------------
//MARK: Interest Activitu Status
struct structInterestedActivityStatus {
    let isInterested = "1"
    let NotInterested = "0"
    let BothInterested = "2"
    let CreatorNotInterested = "3"
}
var interestedActivityStatus = structInterestedActivityStatus()

//MARK: --------------------------------------------------------------
//MARK: Media Type
struct structMediaType {
    let image = "0"
    let video = "1"
}
var MediaType = structMediaType()


//MARK: --------------------------------------------------------------
//MARK: API Response Data
var isTestData = "1"

var API_STATUS = "status"
var API_MESSAGE = "message"
var API_DATA = "data"

var FAILED = 0
var SUCCESS = 1
var LIMIT_FINISH = 2
var PASSWORD_WRONG = 2
var ALREADY_LOGIN = 3
