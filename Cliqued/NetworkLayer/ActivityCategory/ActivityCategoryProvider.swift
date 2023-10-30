//
//  ActivityCategoryProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import UIKit
import Moya

enum ActivityCategoryProvider {
    case getActivityCategories
}

extension ActivityCategoryProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.cliqued.app/api")!
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
        var header = ["Accept": "application/json"]
        
        if let userCookie = UserDefaults.standard.string(forKey: kUserCookie), let rememberME = UserDefaults.standard.string(forKey: kUserRememberMe) {
            header["Cookie"] = userCookie + ";" + rememberME
        }
        
        return header
    }
}
