//
//  InterestedActivityClass.swift
//
//  Created by C211 on 22/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct InterestedActivityClass: Codable {

  enum CodingKeys: String, CodingKey {
    case modifiedDate = "modified_date"
    case isDeleted = "is_deleted"
    case isTestdata = "is_testdata"
    case descriptionValue = "description"
    case id
    case userInfo = "user_info"
    case categoryTitle = "category_title"
    case title
    case createdDate = "created_date"
    case userId = "user_id"
    case activityDate = "activity_date"
  }

  var modifiedDate: String?
  var isDeleted: String?
  var isTestdata: String?
  var descriptionValue: String?
  var id: Int?
  var userInfo: [InterestedUserInfo]?
  var categoryTitle: String?
  var title: String?
  var createdDate: String?
  var userId: Int?
  var activityDate: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    descriptionValue = try container.decodeIfPresent(String.self, forKey: .descriptionValue)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    userInfo = try container.decodeIfPresent([InterestedUserInfo].self, forKey: .userInfo)
    categoryTitle = try container.decodeIfPresent(String.self, forKey: .categoryTitle)
    title = try container.decodeIfPresent(String.self, forKey: .title)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    userId = try container.decodeIfPresent(Int.self, forKey: .userId)
    activityDate = try container.decodeIfPresent(String.self, forKey: .activityDate)
  }

}
