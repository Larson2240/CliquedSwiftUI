//
//  VerbosePlugin.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 04.10.2023.
//

import Foundation
import Moya

struct VerbosePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let body = request.httpBody,
           let str = String(data: body, encoding: .utf8) {
            print("request to send: \(str))")
        }
        
        return request
    }
}
