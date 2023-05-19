//
//  ActivityDetails.swift
//
//  Created by C100-132 on 03/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct ActivityDetails: Codable {

  enum CodingKeys: String, CodingKey {
    case address
    case latitude
    case createdDate = "created_date"
    case country
    case isTestdata = "is_testdata"
    case isDeleted = "is_deleted"
    case id
    case state
    case pincode
    case longitude
    case modifiedDate = "modified_date"
    case activityId = "activity_id"
    case city
  }

  var address: String?
  var latitude: String?
  var createdDate: String?
  var country: String?
  var isTestdata: String?
  var isDeleted: String?
  var id: Int?
  var state: String?
  var pincode: String?
  var longitude: String?
  var modifiedDate: String?
  var activityId: Int?
  var city: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    address = try container.decodeIfPresent(String.self, forKey: .address)
    latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    country = try container.decodeIfPresent(String.self, forKey: .country)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    state = try container.decodeIfPresent(String.self, forKey: .state)
    pincode = try container.decodeIfPresent(String.self, forKey: .pincode)
    longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    activityId = try container.decodeIfPresent(Int.self, forKey: .activityId)
    city = try container.decodeIfPresent(String.self, forKey: .city)
  }

}
