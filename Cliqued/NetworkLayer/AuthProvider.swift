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
        case .logout:
            return "/logout"
        case .verifyOTPForRegister(let token):
            return "/verifyOTPForRegister/\(token)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .register, .logout:
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
        case .logout:
            return .requestPlain
        case .verifyOTPForRegister:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
