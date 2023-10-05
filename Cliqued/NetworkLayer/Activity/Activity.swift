//
//  Activity.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.09.2023.
//

import Foundation

struct Activity: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let parentID: Int?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parentId"
        case title
    }
}
