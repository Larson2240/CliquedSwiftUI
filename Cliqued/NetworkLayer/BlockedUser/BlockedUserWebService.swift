//
//  BlockedUserWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import Foundation
import Moya

final class BlockedUserWebService {
    private let blockedUserProvider = MoyaProvider<BlockedUserProvider>()
    
    func getBlockedUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        blockedUserProvider.request(.getBlockedUsers) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([User].self, from: response.data)
                    completion(.success(model))
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
    
    func blockUser(parameters: [String: Any], completion: @escaping (Result<[User], Error>) -> Void) {
        blockedUserProvider.request(.blockUser(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([User].self, from: response.data)
                    completion(.success(model))
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
    
    func updateBlockedUser(
        userID: String,
        parameters: [String: Any],
        completion: @escaping (Result<[User], Error>) -> Void
    ) {
        blockedUserProvider.request(.updateBlockedUser(userID: userID, parameters: parameters)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([User].self, from: response.data)
                    completion(.success(model))
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
