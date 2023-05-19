//
//  SubscriptionPlanClass.swift
//
//  Created by C211 on 28/02/23
//  Copyright (c) . All rights reserved.
//

import Foundation

struct SubscriptionPlanClass: Codable {
    
    enum CodingKeys: String, CodingKey {
        case modifiedDate = "modified_date"
        case id
        case isBestPlan = "is_best_plan"
        case noOfLikesUser = "no_of_likes_user"
        case subTitle = "sub_title"
        case title
        case createdDate = "created_date"
        case price
        case isDeleted = "is_deleted"
        case storeProductId = "store_product_id"
        case isFree = "is_free"
        case noOfCreatedActivity = "no_of_created_activity"
        case planDuration = "plan_duration"
        case isTestdata = "is_testdata"
        case noOfViewUser = "no_of_view_user"
        case isSelectedPlan = "is_selected_plan"
    }
    
    var modifiedDate: String?
    var id: Int?
    var isBestPlan: String?
    var noOfLikesUser: Int?
    var subTitle: String?
    var title: String?
    var createdDate: String?
    var price: String?
    var isDeleted: String?
    var storeProductId: String?
    var isFree: String?
    var noOfCreatedActivity: Int?
    var planDuration: String?
    var isTestdata: String?
    var noOfViewUser: Int?
    var isSelectedPlan: Bool = false
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        modifiedDate = try container.decodeIfPresent(String.self, forKey: .modifiedDate)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        isBestPlan = try container.decodeIfPresent(String.self, forKey: .isBestPlan)
        noOfLikesUser = try container.decodeIfPresent(Int.self, forKey: .noOfLikesUser)
        subTitle = try container.decodeIfPresent(String.self, forKey: .subTitle)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        createdDate = try container.decodeIfPresent(String.self, forKey: .createdDate)
        price = try container.decodeIfPresent(String.self, forKey: .price)
        isDeleted = try container.decodeIfPresent(String.self, forKey: .isDeleted)
        storeProductId = try container.decodeIfPresent(String.self, forKey: .storeProductId)
        isFree = try container.decodeIfPresent(String.self, forKey: .isFree)
        noOfCreatedActivity = try container.decodeIfPresent(Int.self, forKey: .noOfCreatedActivity)
        planDuration = try container.decodeIfPresent(String.self, forKey: .planDuration)
        isTestdata = try container.decodeIfPresent(String.self, forKey: .isTestdata)
        noOfViewUser = try container.decodeIfPresent(Int.self, forKey: .noOfViewUser)
        isSelectedPlan = try container.decodeIfPresent(Bool.self, forKey: .isSelectedPlan) ?? false
    }
    
}
