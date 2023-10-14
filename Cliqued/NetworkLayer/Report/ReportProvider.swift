//
//  ReportProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import UIKit
import Moya

enum ReportProvider {
    case getReportReasons
    case reportUser(parameters: [String: Any])
}

extension ReportProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://cliqued.michal.es/api")!
    }
    
    var path: String {
        switch self {
        case .getReportReasons:
            return "/report_reasons"
        case .reportUser:
            return "/reported_users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getReportReasons:
            return .get
        case .reportUser:
            return .post
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .getReportReasons:
            return .requestPlain
        case .reportUser(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var header = ["Accept": "application/json"]
        
        if let userCookie = UserDefaults.standard.string(forKey: kUserCookie) {
            header["Cookie"] = userCookie
        }
        
        return header
    }
}
