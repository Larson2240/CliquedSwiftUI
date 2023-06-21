//
//  UserProfileImages.swift
//
//  Created by C211 on 25/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct UserProfileImages: Codable, Identifiable, Equatable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case isTestdata = "is_testdata"
        case createdDate = "created_date"
        case thumbnailUrl = "thumbnail_url"
        case mediaType = "media_type"
        case isDeleted = "is_deleted"
        case url
        case modifiedDate = "modified_date"
    }
    
    var id: Int?
    var userId: Int?
    var isTestdata: String?
    var createdDate: String?
    var thumbnailUrl: String?
    var mediaType: String?
    var isDeleted: String?
    var url: String?
    var modifiedDate: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        thumbnailUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailUrl)
        mediaType = try container.decodeIfPresent(String.self, forKey: .mediaType)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
    }
}
