//
//  SubTypes.swift
//
//  Created by C211 on 30/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct SubTypes: Codable {
    
    enum CodingKeys: String, CodingKey {
        case modifiedDate = "modified_date"
        case id
        case icon
        case typeOptions = "type_options"
        case isTestdata = "is_testdata"
        case parentId = "parent_id"
        case title
        case createdDate = "created_date"
        case isDeleted = "is_deleted"
        case typesOfPreference = "types_of_preference"
    }
    
    var modifiedDate: String?
    var id: Int?
    var icon: String?
    var typeOptions: [TypeOptions]?
    var isTestdata: String?
    var parentId: Int?
    var title: String?
    var createdDate: String?
    var isDeleted: String?
    var typesOfPreference: String?
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        icon = try container.decodeIfPresent(String.self, forKey: .icon)
        typeOptions = try container.decodeIfPresent([TypeOptions].self, forKey: .typeOptions)
        isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
        parentId = try container.decodeIfPresent(Int.self, forKey: .parentId)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        typesOfPreference = try container.decodeIfPresent(String.self, forKey: .typesOfPreference)
    }
    
}
