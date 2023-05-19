//
//  RelationshipClass.swift
//
//  Created by C211 on 30/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct PreferenceClass: Codable {
    
    enum CodingKeys: String, CodingKey {
        case createdDate = "created_date"
        case title
        case modifiedDate = "modified_date"
        case id
        case isTestdata = "is_testdata"
        case isDeleted = "is_deleted"
        case parentId = "parent_id"
        case icon
        case subTypes = "sub_types"
        case typesOfPreference = "types_of_preference"
        case typeOptions = "type_options"
    }
    
    var createdDate: String?
    var title: String?
    var modifiedDate: String?
    var id: Int?
    var isTestdata: String?
    var isDeleted: String?
    var parentId: Int?
    var icon: String?
    var typesOfPreference: String?
    var subTypes: [SubTypes]?
    var typeOptions: [TypeOptions]?
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        parentId = try container.decodeIfPresent(Int.self, forKey: .parentId)
        icon = try container.decodeIfPresent(String.self, forKey: .icon)
        typesOfPreference = try container.decodeIfPresent(String.self, forKey: .typesOfPreference)
        subTypes = try container.decodeIfPresent([SubTypes].self, forKey: .subTypes)
        typeOptions = try container.decodeIfPresent([TypeOptions].self, forKey: .typeOptions)
    }
}
