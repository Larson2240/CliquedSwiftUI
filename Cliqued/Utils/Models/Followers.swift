//
//  Followers.swift
//
//  Created by C211 on 15/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct Followers: Codable {
    
    enum CodingKeys: String, CodingKey {
        case followStatusCounter = "follow_status_counter"
        case modifiedDate = "modified_date"
        case isMeetup = "is_meetup"
        case userId = "user_id"
        case counterUserId = "counter_user_id"
        case isTestdata = "is_testdata"
        case createdDate = "created_date"
        case followDate = "follow_date"
        case id
        case isDeleted = "is_deleted"
        case nextVisibleDate = "next_visible_date"
        case isFollow = "is_follow"
        
        case receiverProfile = "receiver_profile"
        case receiverName = "receiver_name"
        case senderProfile = "sender_profile"
        case senderName = "sender_name"
        
        case receiverIsBlockedByAdmin = "_receiver_is_blocked_by_admin"
        case receiverIsBlockedByUser = "receiver_is_blocked_by_user"
        case receiverLastSeen = "receiver_last_seen"
        case receiverIsLastSeenEnabled = "receiver_is_last_seen_enabled"
        case receiverChatStatus = "receiver_chat_status"
        case receiverIsOnline = "receiver_is_online"
        
        case senderIsBlockedByAdmin = "_sender_is_blocked_by_admin"
        case senderIsBlockedByUser = "sender_is_blocked_by_user"
        case senderLastSeen = "sender_last_seen"
        case senderIsLastSeenEnabled = "sender_is_last_seen_enabled"
        case senderChatStatus = "sender_chat_status"
        case senderIsOnline = "sender_is_online"
        
        case conversationId = "conversation_id"
        case isInterested = "is_interested"
    }
    
    var followStatusCounter: Int?
    var modifiedDate: String?
    var isMeetup: Int?
    var userId: Int?
    var counterUserId: Int?
    var isTestdata: String?
    var createdDate: String?
    var followDate: String?
    var id: Int?
    var isDeleted: String?
    var nextVisibleDate: String?
    var isFollow: String?
    
    var receiverProfile: String?
    var receiverName: String?
    var senderProfile: String?
    var senderName: String?
    
    var receiverIsBlockedByAdmin: String?
    var receiverIsBlockedByUser: String?
    var receiverLastSeen: String?
    var receiverIsLastSeenEnabled: String?
    var receiverChatStatus: String?
    var receiverIsOnline: String?
    
    var senderIsBlockedByAdmin: String?
    var senderIsBlockedByUser: String?
    var senderLastSeen: String?
    var senderIsLastSeenEnabled: String?
    var senderChatStatus: String?
    var senderIsOnline: String?
    
    var conversationId: Int?
    var isInterested : String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        followStatusCounter = try container.decodeIfPresent(Int.self, forKey: .followStatusCounter)
        modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
        isMeetup = try container.decodeIfPresent(Int.self, forKey: .isMeetup)
        userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        counterUserId = try container.decodeIfPresent(Int.self, forKey: .counterUserId)
        isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        followDate = try container.decodeIfPresent(String.self, forKey: .followDate)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        nextVisibleDate = try container.decodeIfPresent(String.self, forKey: .nextVisibleDate)
        isFollow = try container.decodeIfPresent(String.self, forKey: .isFollow)
        
        receiverProfile = try container.decodeIfPresent(String.self, forKey: .receiverProfile)
        receiverName = try container.decodeIfPresent(String.self, forKey: .receiverName)
        senderProfile = try container.decodeIfPresent(String.self, forKey: .senderProfile)
        senderName = try container.decodeIfPresent(String.self, forKey: .senderName)
        
        receiverIsBlockedByAdmin = try container.decodeIfPresent(String.self, forKey: .receiverIsBlockedByAdmin)
        receiverIsBlockedByUser = try container.decodeIfPresent(String.self, forKey: .receiverIsBlockedByUser)
        receiverLastSeen = try container.decodeIfPresent(String.self, forKey: .receiverLastSeen)
        receiverIsLastSeenEnabled = try container.decodeIfPresent(String.self, forKey: .receiverIsLastSeenEnabled)
        receiverChatStatus = try container.decodeIfPresent(String.self, forKey: .receiverChatStatus)
        receiverIsOnline = try container.decodeIfPresent(String.self, forKey: .receiverIsOnline)
        
        senderIsBlockedByAdmin = try container.decodeIfPresent(String.self, forKey: .senderIsBlockedByAdmin)
        senderIsBlockedByUser = try container.decodeIfPresent(String.self, forKey: .senderIsBlockedByUser)
        senderLastSeen = try container.decodeIfPresent(String.self, forKey: .senderLastSeen)
        senderIsLastSeenEnabled = try container.decodeIfPresent(String.self, forKey: .senderIsLastSeenEnabled)
        senderChatStatus = try container.decodeIfPresent(String.self, forKey: .senderChatStatus)
        senderIsOnline = try container.decodeIfPresent(String.self, forKey: .senderIsOnline)
        
        conversationId = try container.decodeIfPresent(Int.self, forKey: .conversationId)
        isInterested = try container.decodeIfPresent(String.self, forKey: .isInterested)
    }
    
}
