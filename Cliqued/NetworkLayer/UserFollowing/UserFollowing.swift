//
//  UserFollowing.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 17.10.2023.
//

import Foundation

struct UserFollowing: Codable {
    let counterUser: String
    let follow, match: Bool
}
