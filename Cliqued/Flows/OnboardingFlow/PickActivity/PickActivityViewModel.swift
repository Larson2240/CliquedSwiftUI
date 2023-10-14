//
//  PickActivityViewModel.swift
//  Cliqued
//
//  Created by C211 on 07/02/23.
//

import SwiftUI

final class PickActivityViewModel: ObservableObject {
    @Published var arrayOfActivity = [Activity]()
    
    private let activityCategoryWebService = ActivityCategoryWebService()
    
    //MARK: Call Get Preferences Data API
    func callGetActivityDataAPI(completion: @escaping () -> Void) {
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        if let allActivities = Constants.activityCategories {
            arrayOfActivity = allActivities
            completion()
        } else {
            UIApplication.shared.showLoader()
            
            activityCategoryWebService.getActivityCategories { [weak self] result in
                UIApplication.shared.hideLoader()
                
                switch result {
                case .success(let activityArray):
                    self?.arrayOfActivity = activityArray
                    Constants.activityCategories = activityArray
                    
                    completion()
                case .failure(let error):
                    UIApplication.shared.showAlertPopup(message: error.localizedDescription)
                }
            }
        }
    }
}
