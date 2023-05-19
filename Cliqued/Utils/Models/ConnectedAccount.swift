//
//  ConnectedAccount.swift
//
//  Created by C211 on 25/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ConnectedAccount: Codable {

  enum CodingKeys: String, CodingKey {
    case isDeleted = "is_deleted"
    case emailId = "email_id"
    case parentId = "parent_id"
    case id
    case isTestdata = "is_testdata"
    case loginType = "login_type"
    case userId = "user_id"
    case socialMediaId = "social_media_id"
    case createdDate = "created_date"
    case modifiedDate = "modified_date"
  }

  var isDeleted: String?
  var emailId: String?
  var parentId: Int?
  var id: Int?
  var isTestdata: String?
  var loginType: String?
  var userId: Int?
  var socialMediaId: String?
  var createdDate: String?
  var modifiedDate: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
    emailId = try container.decodeIfPresent(String.self, forKey: .emailId)
    parentId = try container.decodeIfPresent(Int.self, forKey: .parentId)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    loginType = try container.decodeIfPresent(String.self, forKey: .loginType)
    userId = try container.decodeIfPresent(Int.self, forKey: .userId)
    socialMediaId = try container.decodeIfPresent(String.self, forKey: .socialMediaId)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
  }

}
