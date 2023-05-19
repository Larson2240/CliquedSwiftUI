//
//  UserInfo.swift
//
//  Created by C211 on 22/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct InterestedUserInfo: Codable {
    
    enum CodingKeys: String, CodingKey {
        case isInterested = "is_interested"
        case id
        case age
        case interestedUserId = "interested_user_id"
        case birthdate
        case userDistanceInKm = "user_distance_in_km"
        case modifiedDate = "modified_date"
        case isDeleted = "is_deleted"
        case userActivityDistanceInKm = "user_activity_distance_in_km"
        case activityId = "activity_id"
        case name
        case createdDate = "created_date"
        case isTestdata = "is_testdata"
        case userProfile = "user_profile"
        
        case conversation_id = "conversation_id"
        case receiver_is_blocked_by_user = "receiver_is_blocked_by_user"
        case chat_status = "chat_status"
        case receiver_last_seen = "receiver_last_seen"
        case is_blocked_by_admin = "is_blocked_by_admin"
        case is_last_seen_enabled = "is_last_seen_enabled"
        case receiver_is_online = "receiver_is_online"
        
    }
    
    var isInterested: String?
    var id: Int?
    var age: Int?
    var interestedUserId: Int?
    var birthdate: String?
    var userDistanceInKm: Double?
    var modifiedDate: String?
    var isDeleted: String?
    var userActivityDistanceInKm: Double?
    var activityId: Int?
    var name: String?
    var createdDate: String?
    var isTestdata: String?
    var userProfile: String?
    
    var conversation_id: Int?
    var receiver_is_blocked_by_user: String?
    var chat_status: String?
    var receiver_last_seen: String?
    var is_blocked_by_admin: String?
    var is_last_seen_enabled: String?
    var receiver_is_online: String?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isInterested = try container.decodeIfPresent(String.self, forKey: .isInterested)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        age = try container.decodeIfPresent(Int.self, forKey: .age)
        interestedUserId = try container.decodeIfPresent(Int.self, forKey: .interestedUserId)
        birthdate = try container.decodeIfPresent(String.self, forKey: .birthdate)
        userDistanceInKm = try container.decodeIfPresent(Double.self, forKey: .userDistanceInKm)
        modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        userActivityDistanceInKm = try container.decodeIfPresent(Double.self, forKey: .userActivityDistanceInKm)
        activityId = try container.decodeIfPresent(Int.self, forKey: .activityId)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
        userProfile = try container.decodeIfPresent(String.self, forKey: .userProfile)
        
        
        receiver_is_blocked_by_user = try container.decodeIfPresent(String.self, forKey: .receiver_is_blocked_by_user)
        chat_status = try container.decodeIfPresent(String.self, forKey: .chat_status)
        receiver_last_seen = try container.decodeIfPresent(String.self, forKey: .receiver_last_seen)
        is_blocked_by_admin = try container.decodeIfPresent(String.self, forKey: .is_blocked_by_admin)
        is_last_seen_enabled = try container.decodeIfPresent(String.self, forKey: .is_last_seen_enabled)
        receiver_is_online = try container.decodeIfPresent(String.self, forKey: .receiver_is_online)
        conversation_id = try container.decodeIfPresent(Int.self, forKey: .conversation_id)
    }
    
}
