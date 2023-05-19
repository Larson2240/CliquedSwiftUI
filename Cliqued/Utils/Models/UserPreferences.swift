//
//  UserPreferences.swift
//
//  Created by C211 on 25/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct UserPreferences: Codable {
    
    enum CodingKeys: String, CodingKey {
        case isDeleted = "is_deleted"
        case preferenceOptionTitle = "preference_option_title"
        case id
        case preferenceId = "preference_id"
        case isTestdata = "is_testdata"
        case preferenceOptionId = "preference_option_id"
        case userId = "user_id"
        case preferenceTitle = "preference_title"
        case modifiedDate = "modified_date"
        case createdDate = "created_date"
        
        case typesOfPreference = "types_of_preference"
        case typesOfOptions = "types_of_options"
        case parentId = "parent_id"
        case subTypesOfPreference = "sub_types_of_preference"
        case subPreferenceTitle = "sub_preference_title"
    }
    
    var isDeleted: String?
    var preferenceOptionTitle: String?
    var id: Int?
    var preferenceId: Int?
    var isTestdata: String?
    var preferenceOptionId: Int?
    var userId: Int?
    var preferenceTitle: String?
    var modifiedDate: String?
    var createdDate: String?
    
    var typesOfPreference: String?
    var typesOfOptions: String?
    var parentId: Int?
    var subTypesOfPreference: String?
    var subPreferenceTitle: String?
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        preferenceOptionTitle = try container.decodeIfPresent(String.self, forKey: .preferenceOptionTitle)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        preferenceId = try container.decodeIfPresent(Int.self, forKey: .preferenceId)
        isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
        preferenceOptionId = try container.decodeIfPresent(Int.self, forKey: .preferenceOptionId)
        userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        preferenceTitle = try container.decodeIfPresent(String.self, forKey: .preferenceTitle)
        modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        
        typesOfPreference = try container.decodeIfPresent(String.self, forKey: .typesOfPreference)
        typesOfOptions = try container.decodeIfPresent(String.self, forKey: .typesOfOptions)
        parentId = try container.decodeIfPresent(Int.self, forKey: .parentId)
        subTypesOfPreference = try container.decodeIfPresent(String.self, forKey: .subTypesOfPreference)
        subPreferenceTitle = try container.decodeIfPresent(String.self, forKey: .subPreferenceTitle)
    }
    
}
