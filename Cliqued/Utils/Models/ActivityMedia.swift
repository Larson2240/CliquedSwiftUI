//
//  ActivityMedia.swift
//
//  Created by C100-132 on 03/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ActivityMedia: Codable {

  enum CodingKeys: String, CodingKey {
    case activityId = "activity_id"
    case mediaType = "media_type"
    case url
    case isTestdata = "is_testdata"
    case modifiedDate = "modified_date"
    case createdDate = "created_date"
    case id
    case thumbnailUrl = "thumbnail_url"
    case isDeleted = "is_deleted"
  }

  var activityId: Int?
  var mediaType: String?
  var url: String?
  var isTestdata: String?
  var modifiedDate: String?
  var createdDate: String?
  var id: Int?
  var thumbnailUrl: String?
  var isDeleted: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    activityId = try container.decodeIfPresent(Int.self, forKey: .activityId)
    mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType)
    url = try container.decodeIfPresent(String.self, forKey: .url)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    thumbnailUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailUrl)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
  }

}
