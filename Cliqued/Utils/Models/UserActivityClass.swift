//
//  UserActivityClass.swift
//
//  Created by C100-132 on 03/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct UserActivityClass: Codable {

  enum CodingKeys: String, CodingKey {
    case isTestdata = "is_testdata"
    case activityDate = "activity_date"
    case createdDate = "created_date"
    case activitySubCategory = "activity_sub_category"
    case modifiedDate = "modified_date"
    case userId = "user_id"
    case id
    case title
    case activityMedia = "activity_media"
    case interestedCount = "interested_count"
    case descriptionValue = "description"
    case isDeleted = "is_deleted"
    case activityCategoryTitle = "activity_category_title"
    case activityDetails = "activity_details"
      case userProfile = "user_profile"
      case interestedActivityStatus = "interested_activity_status"
  }

  var isTestdata: String?
  var activityDate: String?
  var createdDate: String?
  var activitySubCategory: [ActivitySubCategory]?
  var modifiedDate: String?
  var userId: Int?
  var id: Int?
  var title: String?
  var activityMedia: [ActivityMedia]?
  var interestedCount: Int?
  var descriptionValue: String?
  var isDeleted: String?
  var activityCategoryTitle: String?
  var activityDetails: [ActivityDetails]?
    var userProfile : String?
    var interestedActivityStatus : String?


  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    activityDate = try container.decodeIfPresent(String.self, forKey: .activityDate)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    activitySubCategory = try container.decodeIfPresent([ActivitySubCategory].self, forKey: .activitySubCategory)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    userId = try container.decodeIfPresent(Int.self, forKey: .userId)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    title = try container.decodeIfPresent(String.self, forKey: .title)
    activityMedia = try container.decodeIfPresent([ActivityMedia].self, forKey: .activityMedia)
    interestedCount = try container.decodeIfPresent(Int.self, forKey: .interestedCount)
    descriptionValue = try container.decodeIfPresent(String.self, forKey: .descriptionValue)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
    activityCategoryTitle = try container.decodeIfPresent(String.self, forKey: .activityCategoryTitle)
    activityDetails = try container.decodeIfPresent([ActivityDetails].self, forKey: .activityDetails)
      userProfile = try container.decodeIfPresent(String.self, forKey: .userProfile)
      interestedActivityStatus = try container.decodeIfPresent(String.self, forKey: .interestedActivityStatus)
  }

}
