//
//  ActivityCategoryClass.swift
//
//  Created by C211 on 07/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ActivityCategoryClass: Codable {

  enum CodingKeys: String, CodingKey {
    case parentId = "parent_id"
    case isTestdata = "is_testdata"
    case image
    case createdDate = "created_date"
    case modifiedDate = "modified_date"
    case icon
    case subCategory = "Sub_Category"
    case isDeleted = "is_deleted"
    case title
    case id
  }

  var parentId: Int?
  var isTestdata: String?
  var image: String?
  var createdDate: String?
  var modifiedDate: String?
  var icon: String?
  var subCategory: [SubCategory]?
  var isDeleted: String?
  var title: String?
  var id: Int?
  


  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    parentId = try container.decodeIfPresent(Int.self, forKey: .parentId)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    image = try container.decodeIfPresent(String.self, forKey: .image)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    icon = try container.decodeIfPresent(String.self, forKey: .icon)
    subCategory = try container.decodeIfPresent([SubCategory].self, forKey: .subCategory)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
    title = try container.decodeIfPresent(String.self, forKey: .title)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
  }

}
