//
//  ApiError.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 27.09.2023.
//

import Foundation

enum ApiError {
    case parsing
    case profileNotFound
    case custom(errorDescription: String)
}

extension ApiError: Error {
    var errorDescription: String? {
        switch self {
        case .parsing: return "Parsing error"
        case .profileNotFound: return "Profile Not Found"
        case .custom(let errorDescription): return errorDescription
        }
    }
}
