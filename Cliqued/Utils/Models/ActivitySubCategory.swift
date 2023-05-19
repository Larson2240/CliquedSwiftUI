//
//  ActivitySubCategory.swift
//
//  Created by C100-132 on 03/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ActivitySubCategory: Codable {

  enum CodingKeys: String, CodingKey {
    case activityId = "activity_id"
    case id
    case isTestdata = "is_testdata"
    case modifiedDate = "modified_date"
    case createdDate = "created_date"
    case activityCategoryId = "activity_category_id"
    case subCategoryId = "sub_category_id"
    case isDeleted = "is_deleted"
  }

  var activityId: Int?
  var id: Int?
  var isTestdata: String?
  var modifiedDate: String?
  var createdDate: String?
  var activityCategoryId: Int?
  var subCategoryId: Int?
  var isDeleted: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    activityId = try container.decodeIfPresent(Int.self, forKey: .activityId)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    activityCategoryId = try container.decodeIfPresent(Int.self, forKey: .activityCategoryId)
    subCategoryId = try container.decodeIfPresent(Int.self, forKey: .subCategoryId)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
  }

}
