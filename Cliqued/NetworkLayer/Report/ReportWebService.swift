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
    
    func getReportReasons(completion: @escaping (Result<[ReportReason], Error>) -> Void) {
        reportProvider.request(.getReportReasons) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode([ReportReason].self, from: response.data)
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
    
    func reportUser(parameters: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        reportProvider.request(.reportUser(parameters: parameters)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204 {
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
