//
//  PasswordWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import Foundation
import Moya

final class PasswordWebService {
    private let passwordProvider = MoyaProvider<PasswordProvider>()
    
    func changePassword(parameters: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        passwordProvider.request(.changePassword(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 || response.statusCode == 201 {
                    completion(.success(Void()))
                } else {
                    completion(.failure(ApiError.parsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendOTPForPassword(parameters: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        passwordProvider.request(.sendOTPForPassword(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 || response.statusCode == 201 {
                    completion(.success(Void()))
                } else {
                    completion(.failure(ApiError.parsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateBlockedUser(token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        passwordProvider.request(.verifyOTPForPassword(token: token)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 || response.statusCode == 201 {
                    completion(.success(Void()))
                } else {
                    completion(.failure(ApiError.parsing))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
