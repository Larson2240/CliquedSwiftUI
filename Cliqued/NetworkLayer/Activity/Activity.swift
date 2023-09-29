//
//  Activity.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.09.2023.
//

import Foundation

struct Activity: Codable, Identifiable, Equatable {
    let id: Int
    let icon: String?
    let parentID: Int?
    let image: String?
    let title: String

    enum CodingKeys: String, CodingKey {
        case id, icon
        case parentID = "parentId"
        case image, title
    }
}
