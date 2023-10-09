//
//  MatchesProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 08.10.2023.
//

import UIKit
import Moya

enum MatchesProvider {
    case getMatchingActivities
    case getMatchesForActivity(activityID: String)
    case getMatchesHome
}

extension MatchesProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://cliqued.michal.es/api")!
    }
    
    var path: String {
        switch self {
        case .getMatchingActivities:
            return "/matching/activities"
        case .getMatchesForActivity(let id):
            return "/matching/activities/\(id)/users"
        case .getMatchesHome:
            return "/matching/home"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        var header = ["Accept": "application/json"]
        
        if let userCookie = UserDefaults.standard.string(forKey: kUserCookie) {
            header["Cookie"] = userCookie
        }
        
        return header
    }
}
