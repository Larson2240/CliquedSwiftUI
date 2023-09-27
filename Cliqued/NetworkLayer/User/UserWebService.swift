//
//  UserWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 27.09.2023.
//

import Foundation
import Moya

final class UserWebService {
    private let userProvider = MoyaProvider<UserProvider>()
    
    func getUser(completion: @escaping (Result<User, Error>) -> Void) {
        userProvider.request(.getUser) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(ApiUserModel.self, from: response.data)
                    completion(.success(model.user))
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
    
    func deleteUser(completion: @escaping (Result<Void, Error>) -> Void) {
        userProvider.request(.deleteUser) { result in
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
    
    func updateUser(
        user: User,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        userProvider.request(.updateUser(user: user)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(ApiUserModel.self, from: response.data)
                    completion(.success(model.user))
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
