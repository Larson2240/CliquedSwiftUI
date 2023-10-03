//
//  AuthProvider.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 08.09.2023.
//

import Foundation
import Moya

enum AuthProvider {
    case login(email: String, password: String)
    case register(email: String, password: String)
    case social(socialID: String, loginType: Int)
    case logout
    case verifyOTPForRegister(token: String)
}

extension AuthProvider: TargetType {
    var baseURL: URL {
        return URL(string: "https://cliqued.michal.es/api")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register"
        case .social:
            return "/social"
        case .logout:
            return "/logout"
        case .verifyOTPForRegister(let token):
            return "/verifyOTPForRegister/\(token)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register, .social, .logout:
            return .post
        case .verifyOTPForRegister:
            return .get
        }
    }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        switch self {
        case .login(let email, let password):
            return .requestParameters(parameters: ["username": email, "password": password],
                                      encoding: JSONEncoding.default)
        case .register(let email, let password):
            return .requestParameters(parameters: ["email": email,
                                                   "password": password,
                                                   "repeatPassword": password],
                                      encoding: JSONEncoding.default)
        case .social(let socialID, let loginType):
            let deviceToken = UserDefaults.standard.string(forKey: kDeviceToken)
            
            return .requestParameters(parameters: ["social_id": socialID,
                                                   "login_type": loginType,
                                                   "device_type": 1,
                                                   "device_token": deviceToken ?? ""],
                                      encoding: JSONEncoding.default)
        case .logout:
            return .requestPlain
        case .verifyOTPForRegister:
            return .requestPlain
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
