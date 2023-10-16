//
//  MatchesWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 08.10.2023.
//

import SwiftUI
import Moya

final class MatchesWebService {
    private let matchesProvider = MoyaProvider<MatchesProvider>(plugins: [VerbosePlugin()])
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    func getMatchingActivities(completion: @escaping (Result<[UserActivity], Error>) -> Void) {
        matchesProvider.request(.getMatchingActivities) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([UserActivity].self, from: response.data)
                    completion(.success(model))
                } catch let error {
                    print(error)
                    
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
    
    func getMatchesForActivity(for id: String, completion: @escaping (Result<[User], Error>) -> Void) {
        matchesProvider.request(.getMatchesForActivity(activityID: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([User].self, from: response.data)
                    completion(.success(model))
                } catch let error {
                    print(error)
                    
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
    
    func getMatchesHome(completion: @escaping (Result<[User], Error>) -> Void) {
        matchesProvider.request(.getMatchesHome) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([User].self, from: response.data)
                    completion(.success(model))
                } catch let error {
                    print(error)
                    
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
