//
//  AuthWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 27.09.2023.
//

import Foundation
import Moya

final class AuthWebService {
    private let authProvider = MoyaProvider<AuthProvider>()
    
    func register(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        authProvider.request(.register(email: email, password: password)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(TokenModel.self, from: response.data)
                    completion(.success(model.token))
                } catch {
                    if let model = try? JSONDecoder().decode(ApiErrorModel.self, from: response.data) {
                        completion(.failure(ApiError.custom(errorDescription: model.message)))
                    } else {
                        completion(.failure(ApiError.parsing))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        authProvider.request(.login(email: email, password: password)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(TokenModel.self, from: response.data)
                    completion(.success(model.token))
                } catch {
                    if let model = try? JSONDecoder().decode(ApiErrorModel.self, from: response.data) {
                        completion(.failure(ApiError.custom(errorDescription: model.message)))
                    } else {
                        completion(.failure(ApiError.parsing))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func social(
        socialID: String,
        loginType: Int,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        authProvider.request(.social(socialID: socialID, loginType: loginType)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(TokenModel.self, from: response.data)
                    completion(.success(model.token))
                } catch {
                    if let model = try? JSONDecoder().decode(ApiErrorModel.self, from: response.data) {
                        completion(.failure(ApiError.custom(errorDescription: model.message)))
                    } else {
                        completion(.failure(ApiError.parsing))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
