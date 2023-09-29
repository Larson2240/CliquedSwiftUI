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
        guard let userToken = UserDefaults.standard.string(forKey: kUserToken) else {
            return nil
        }
        
        var header = ["Authorization": "Bearer \(userToken)",
                      "Accept": "application/json"]
        
        for headerKey in includeSecurityCredentials() {
            header[headerKey.key as! String] = headerKey.value as? String
        }
        
        return header
    }
}
