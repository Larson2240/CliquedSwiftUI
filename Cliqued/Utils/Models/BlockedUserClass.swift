//
//  BlockedUserClass.swift
//
//  Created by C100-132 on 10/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct BlockedUserClass: Codable {

  enum CodingKeys: String, CodingKey {
    case blockedType = "blocked_type"
    case isDeleted = "is_deleted"
    case userId = "user_id"
    case modifiedDate = "modified_date"
    case userProfile = "user_profile"
    case isTestdata = "is_testdata"
    case createdDate = "created_date"
    case name
    case counterUserId = "counter_user_id"
    case id
    case isBlocked = "is_blocked"
  }

  var blockedType: String?
  var isDeleted: String?
  var userId: Int?
  var modifiedDate: String?
  var userProfile: String?
  var isTestdata: String?
  var createdDate: String?
  var name: String?
  var counterUserId: Int?
  var id: Int?
  var isBlocked: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    blockedType = try container.decodeIfPresent(String.self, forKey: .blockedType)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
    userId = try container.decodeIfPresent(Int.self, forKey: .userId)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    userProfile = try container.decodeIfPresent(String.self, forKey: .userProfile)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    name = try container.decodeIfPresent(String.self, forKey: .name)
    counterUserId = try container.decodeIfPresent(Int.self, forKey: .counterUserId)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    isBlocked = try container.decodeIfPresent(String.self, forKey: .isBlocked)
  }

}
