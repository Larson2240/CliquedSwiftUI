//
//  SubCategory.swift
//
//  Created by C211 on 07/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct SubCategory: Codable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case isTestdata = "is_testdata"
        case icon
        case id
        case isDeleted = "is_deleted"
        case image
        case parentId = "parent_id"
        case modifiedDate = "modified_date"
        case createdDate = "created_date"
        case title
    }
    
    var isTestdata: String?
    var icon: String?
    var id: Int?
    var isDeleted: String?
    var image: String?
    var parentId: Int?
    var modifiedDate: String?
    var createdDate: String?
    var title: String?
    var isSelected = false
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
        icon = try container.decodeIfPresent(String.self, forKey: .icon)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        parentId = try container.decodeIfPresent(Int.self, forKey: .parentId)
        modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        title = try container.decodeIfPresent(String.self, forKey: .title)
    }
    
}
