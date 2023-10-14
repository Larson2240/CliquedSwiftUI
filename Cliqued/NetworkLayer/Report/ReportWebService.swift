//
//  ReportWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 14.10.2023.
//

import Foundation
import Moya

final class ReportWebService {
    private let reportProvider = MoyaProvider<ReportProvider>(plugins: [VerbosePlugin()])
    
    func getReportReasons(completion: @escaping (Result<[UserActivity], Error>) -> Void) {
        reportProvider.request(.getReportReasons) { result in
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
    
    func reportUser(parameters: [String: Any], completion: @escaping (Result<[User], Error>) -> Void) {
        reportProvider.request(.reportUser(parameters: parameters)) { result in
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
