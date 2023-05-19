//
//  UserLikesMatchesClass.swift
//
//  Created by C100-132 on 31/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct UserLikesMatchesClass: Codable {

  enum CodingKeys: String, CodingKey {
    case createdDate = "created_date"
    case userId = "user_id"
    case followStatusCounter = "follow_status_counter"
    case isTestdata = "is_testdata"
    case counterUserId = "counter_user_id"
    case isMeetup = "is_meetup"
    case nextVisibleDate = "next_visible_date"
    case followDate = "follow_date"
    case id
    case isDeleted = "is_deleted"
    case isFollow = "is_follow"
    case receiverProfile = "receiver_profile"
    case modifiedDate = "modified_date"
    case interestedPeople = "interested_people"
    case receiverName = "receiver_name"
    case receiverLastSeen = "receiver_last_seen"
    case receiverIsOnline = "receiver_is_online"
      case conversationId = "conversation_id"
      case isLastSeenEnabled = "is_last_seen_enabled"
      case chatStatus = "chat_status"
      case isBlockedByAdmin = "is_blocked_by_admin"
      case isBlockedByUser = "is_blocked_by_user"
      case counterUserFollowStatus = "counter_user_follow_status"
      case  blockStatus = "block_status"
  }

  var createdDate: String?
  var userId: Int?
  var followStatusCounter: Int?
  var isTestdata: String?
  var counterUserId: Int?
  var isMeetup: Int?
  var nextVisibleDate: String?
  var followDate: String?
  var id: Int?
  var isDeleted: String?
  var isFollow: String?
  var receiverProfile: String?
  var modifiedDate: String?
  var interestedPeople: Int?
  var receiverName: String?
  var receiverLastSeen: String?
  var receiverIsOnline: String?
    var conversationId: Int?
    var isLastSeenEnabled : String?
    var chatStatus : String?
    var isBlockedByAdmin : String?
    var isBlockedByUser: String?
    var counterUserFollowStatus: String?
    var blockStatus : String?
 

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    userId = try container.decodeIfPresent(Int.self, forKey: .userId)
    followStatusCounter = try container.decodeIfPresent(Int.self, forKey: .followStatusCounter)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    counterUserId = try container.decodeIfPresent(Int.self, forKey: .counterUserId)
    isMeetup = try container.decodeIfPresent(Int.self, forKey: .isMeetup)
    nextVisibleDate = try container.decodeIfPresent(String.self, forKey: .nextVisibleDate)
    followDate = try container.decodeIfPresent(String.self, forKey: .followDate)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
    isFollow = try container.decodeIfPresent(String.self, forKey: .isFollow)
    receiverProfile = try container.decodeIfPresent(String.self, forKey: .receiverProfile)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    interestedPeople = try container.decodeIfPresent(Int.self, forKey: .interestedPeople)
    receiverName = try container.decodeIfPresent(String.self, forKey: .receiverName)
    receiverIsOnline = try container.decodeIfPresent(String.self, forKey: .receiverIsOnline)
    receiverLastSeen = try container.decodeIfPresent(String.self, forKey: .receiverLastSeen)
      conversationId = try container.decodeIfPresent(Int.self, forKey: .conversationId)
      isLastSeenEnabled = try container.decodeIfPresent(String.self, forKey: .isLastSeenEnabled)
      chatStatus = try container.decodeIfPresent(String.self, forKey: .chatStatus)
      isBlockedByAdmin = try container.decodeIfPresent(String.self, forKey: .isBlockedByAdmin)
      isBlockedByUser = try container.decodeIfPresent(String.self, forKey: .isBlockedByUser)
      counterUserFollowStatus = try container.decodeIfPresent(String.self, forKey: .counterUserFollowStatus)
      blockStatus = try container.decodeIfPresent(String.self, forKey: .blockStatus)
  }

}
