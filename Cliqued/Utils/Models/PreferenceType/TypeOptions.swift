//
//  TypeOptions.swift
//
//  Created by C211 on 30/01/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct TypeOptions: Codable {
    
    enum CodingKeys: String, CodingKey {
        case isDeleted = "is_deleted"
        case isTestdata = "is_testdata"
        case id
        case title
        case modifiedDate = "modified_date"
        case preferenceId = "preference_id"
        case createdDate = "created_date"
        case typeOfOptions = "types_of_options"
    }
    
    var isDeleted: String?
    var isTestdata: String?
    var id: Int?
    var title: String?
    var modifiedDate: String?
    var preferenceId: Int?
    var createdDate: String?
    var typeOfOptions: String?
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
        preferenceId = try container.decodeIfPresent(Int.self, forKey: .preferenceId)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        typeOfOptions = try container.decodeIfPresent(String.self, forKey: .typeOfOptions)
    }
    
}
