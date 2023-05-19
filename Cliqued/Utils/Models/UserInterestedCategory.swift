//
//  UserInterestedCategory.swift
//
//  Created by C211 on 25/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct UserInterestedCategory: Codable {

  enum CodingKeys: String, CodingKey {
    case activityId = "activity_id"
    case activitySubCategoryIcon = "activity_sub_category_icon"
    case createdDate = "created_date"
    case isTestdata = "is_testdata"
    case activityCategoryIcon = "activity_category_icon"
    case activityCategoryTitle = "activity_category_title"
    case activitySubCategoryTitle = "activity_sub_category_title"
    case id
    case userId = "user_id"
    case subActivityId = "sub_activity_id"
    case activitySubCategoryImage = "activity_sub_category_image"
    case modifiedDate = "modified_date"
    case isDeleted = "is_deleted"
    case activityCategoryImage = "activity_category_image"
  }

  var activityId: Int?
  var activitySubCategoryIcon: String?
  var createdDate: String?
  var isTestdata: String?
  var activityCategoryIcon: String?
  var activityCategoryTitle: String?
  var activitySubCategoryTitle: String?
  var id: Int?
  var userId: Int?
  var subActivityId: Int?
  var activitySubCategoryImage: String?
  var modifiedDate: String?
  var isDeleted: String?
  var activityCategoryImage: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    activityId = try container.decodeIfPresent(Int.self, forKey: .activityId)
    activitySubCategoryIcon = try container.decodeIfPresent(String.self, forKey: .activitySubCategoryIcon)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    activityCategoryIcon = try container.decodeIfPresent(String.self, forKey: .activityCategoryIcon)
    activityCategoryTitle = try container.decodeIfPresent(String.self, forKey: .activityCategoryTitle)
    activitySubCategoryTitle = try container.decodeIfPresent(String.self, forKey: .activitySubCategoryTitle)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    userId = try container.decodeIfPresent(Int.self, forKey: .userId)
    subActivityId = try container.decodeIfPresent(Int.self, forKey: .subActivityId)
    activitySubCategoryImage = try container.decodeIfPresent(String.self, forKey: .activitySubCategoryImage)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
    activityCategoryImage = try container.decodeIfPresent(String.self, forKey: .activityCategoryImage)
  }

}
