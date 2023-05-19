//
//  User.swift
//
//  Created by C211 on 25/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct User: Codable {
    
    enum CodingKeys: String, CodingKey {
        case isDeleted = "is_deleted"
        case gender
        case name = "name"
        case distanceInkm = "distance_in_km"
        case age = "age"
        case userPreferences = "user_preferences"
        case userAddress = "user_address"
        case modifiedDate = "modified_date"
        case profileSetupType = "profile_setup_type"
        case isProfileSetupCompleted = "is_profile_setup_completed"
        case connectedAccount = "connected_account"
        case isTestdata = "is_testdata"
        case birthdate
        case lastSeen = "last_seen"
        case width
        case isOnline = "is_online"
        case isVerified = "is_verified"
        case userInterestedCategory = "user_interested_category"
        case createdDate = "created_date"
        case id
        case guid
        case userProfileImages = "user_profile_images"
        case likesCounter = "likes_counter"
        case height
        case isBlocked = "is_blocked"
        case userMergeIds = "userMergeIds"
        case isUserLastSeenEnable = "is_user_last_seen_enable"
        
        case kidsSelectionId = "kids_selection_id"
        case smokingSelectionId = "smoking_selection_id"
        case notificationEnableId = "notification_enable_id"
        case ageStartId = "age_start_id"
        case ageEndId = "age_end_id"
        case distanceOptionId = "distance_option_id"
        
        case aboutme = "about_me"
        case chatStatus = "chat_status"
        case activityCount = "activity_count"
        case userProfileViewCount = "user_profile_view_count"
        case activityUserViewCount = "activity_user_view_count"
        case isPremiumUser = "is_premium_user"
        case lookingForTitle = "looking_for_title"
    }
    
    var isDeleted: String?
    var gender: String?
    var name: String?
    var age: Int?
    var distanceInkm: Double?
    var userPreferences: [UserPreferences]?
    var userAddress: [UserAddress]?
    var modifiedDate: String?
    var profileSetupType: String?
    var isProfileSetupCompleted: Int?
    var connectedAccount: [ConnectedAccount]?
    var isTestdata: String?
    var birthdate: String?
    var lastSeen: String?
    var width: String?
    var isOnline: String?
    var isVerified: String?
    var userInterestedCategory: [UserInterestedCategory]?
    var createdDate: String?
    var id: Int?
    var guid: String?
    var userProfileImages: [UserProfileImages]?
    var likesCounter: Int?
    var height: String?
    var isBlocked: String?
    var userMergeIds: String?
    var isUserLastSeenEnable: String?

    var kidsSelectionId: String?
    var smokingSelectionId: String?
    var notificationEnableId: String?
    var ageStartId: String?
    var ageEndId: String?
    var distanceOptionId: String?
    
    var aboutme: String?
    var chatStatus: String?
    var activityCount: Int?
    var userProfileViewCount: Int?
    var activityUserViewCount: Int?
    var isPremiumUser: String?
    var lookingForTitle: String?


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        gender = try container.decodeIfPresent(String.self, forKey: .gender)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        age = try container.decodeIfPresent(Int.self, forKey: .age)
        distanceInkm = try container.decodeIfPresent(Double.self, forKey: .distanceInkm)
        userPreferences = try container.decodeIfPresent([UserPreferences].self, forKey: .userPreferences)
        userAddress = try container.decodeIfPresent([UserAddress].self, forKey: .userAddress)
        modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
        profileSetupType = try container.decodeIfPresent(String.self, forKey: .profileSetupType)
        isProfileSetupCompleted = try container.decodeIfPresent(Int.self, forKey: .isProfileSetupCompleted)
        connectedAccount = try container.decodeIfPresent([ConnectedAccount].self, forKey: .connectedAccount)
        isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
        birthdate = try container.decodeIfPresent(String.self, forKey: .birthdate)
        lastSeen = try container.decodeIfPresent(String.self, forKey: .lastSeen)
        width = try container.decodeIfPresent(String.self, forKey: .width)
        isOnline = try container.decodeIfPresent(String.self, forKey: .isOnline)
        isVerified = try container.decodeIfPresent(String.self, forKey: .isVerified)
        userInterestedCategory = try container.decodeIfPresent([UserInterestedCategory].self, forKey: .userInterestedCategory)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        guid = try container.decodeIfPresent(String.self, forKey: .guid)
        userProfileImages = try container.decodeIfPresent([UserProfileImages].self, forKey: .userProfileImages)
        likesCounter = try container.decodeIfPresent(Int.self, forKey: .likesCounter)
        height = try container.decodeIfPresent(String.self, forKey: .height)
        isBlocked = try container.decodeIfPresent(String.self, forKey: .isBlocked)
        userMergeIds = try container.decodeIfPresent(String.self, forKey: .userMergeIds)
        isUserLastSeenEnable = try container.decodeIfPresent(String.self, forKey: .isUserLastSeenEnable)

        kidsSelectionId = try container.decodeIfPresent(String.self, forKey: .kidsSelectionId)
        smokingSelectionId = try container.decodeIfPresent(String.self, forKey: .smokingSelectionId)
        notificationEnableId = try container.decodeIfPresent(String.self, forKey: .notificationEnableId)
        ageStartId = try container.decodeIfPresent(String.self, forKey: .ageStartId)
        ageEndId = try container.decodeIfPresent(String.self, forKey: .ageEndId)
        distanceOptionId = try container.decodeIfPresent(String.self, forKey: .distanceOptionId)
        
        aboutme = try container.decodeIfPresent(String.self, forKey: .aboutme)
        chatStatus = try container.decodeIfPresent(String.self, forKey: .chatStatus)
        activityCount = try container.decodeIfPresent(Int.self, forKey: .activityCount)
        userProfileViewCount = try container.decodeIfPresent(Int.self, forKey: .userProfileViewCount)
        activityUserViewCount = try container.decodeIfPresent(Int.self, forKey: .activityUserViewCount)
        isPremiumUser = try container.decodeIfPresent(String.self, forKey: .isPremiumUser)
        lookingForTitle = try container.decodeIfPresent(String.self, forKey: .lookingForTitle)
    }
    
}
