//
//  UserAddress.swift
//
//  Created by C211 on 25/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct UserAddress: Codable {

  enum CodingKeys: String, CodingKey {
    case state
    case createdDate = "created_date"
    case city
    case isTestdata = "is_testdata"
    case latitude
    case country
    case longitude
    case id
    case pincode
    case userId = "user_id"
    case modifiedDate = "modified_date"
    case address
    case isDeleted = "is_deleted"
  }

  var state: String?
  var createdDate: String?
  var city: String?
  var isTestdata: String?
  var latitude: String?
  var country: String?
  var longitude: String?
  var id: Int?
  var pincode: String?
  var userId: Int?
  var modifiedDate: String?
  var address: String?
  var isDeleted: String?



  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    state = try container.decodeIfPresent(String.self, forKey: .state)
    createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
    city = try container.decodeIfPresent(String.self, forKey: .city)
    isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
    latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
    country = try container.decodeIfPresent(String.self, forKey: .country)
    longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
    id = try container.decodeIfPresent(Int.self, forKey: .id)
    pincode = try container.decodeIfPresent(String.self, forKey: .pincode)
    userId = try container.decodeIfPresent(Int.self, forKey: .userId)
    modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    address = try container.decodeIfPresent(String.self, forKey: .address)
    isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
  }

}
