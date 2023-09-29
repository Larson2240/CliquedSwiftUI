//
//  ActivityProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.09.2023.
//

import Foundation
import Moya

enum ActivityProvider {
    case getActivityCategories
}

extension ActivityProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://cliqued.michal.es/api")!
    }
    
    var path: String {
        switch self {
        case .getActivityCategories:
            return "/activity_categories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getActivityCategories:
            return .get
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .getActivityCategories:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
}
