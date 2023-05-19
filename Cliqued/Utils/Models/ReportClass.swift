//
//  ReportClass.swift
//
//  Created by C211 on 16/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ReportClass: Codable {

  enum CodingKeys: String, CodingKey {
    case createdDate = "created_date"
    case isDeleted = "is_deleted"
    case modifiedDate = "modified_date"
    case isTestdata = "is_testdata"
    case reasonTitle = "reason_title"
    case id
  }

  var createdDate: String?
  var isDeleted: String?
  var modifiedDate: String?
  var isTestdata: String?
  var reasonTitle: String?
  var id: Int?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    reasonTitle = try container.decodeIfPresent(String.self, forKey: .reasonTitle)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
  }

}
