//
//  ActivityWebService.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 29.09.2023.
//

import Foundation
import Moya

final class ActivityWebService {
    private let activityProvider = MoyaProvider<ActivityProvider>()
    
    func getActivityCategories(completion: @escaping (Result<[Activity], Error>) -> Void) {
        activityProvider.request(.getActivityCategories) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([Activity].self, from: response.data)
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
