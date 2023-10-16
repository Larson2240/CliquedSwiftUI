//
//  SettingsViewModel.swift
//  Cliqued
//
//  Created by C211 on 23/01/23.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    private let userWebService = UserWebService()
    private let authWebService = AuthWebService()
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    func logout() {
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        authWebService.logout { [weak self] result in
            UIApplication.shared.hideLoader()
            
            switch result {
            case .success:
                self?.clearData()
            case .failure(let error):
                if let error = error as? ApiError, let message = error.errorDescription {
                    UIApplication.shared.showAlertPopup(message: message)
                }
            }
        }
    }
    
    func deleteAccount() {
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        userWebService.deleteUser { [weak self] result in
            UIApplication.shared.hideLoader()
            
            switch result {
            case .success:
                self?.clearData()
            case .failure(let error):
                UIApplication.shared.showAlertPopup(message: error.localizedDescription)
            }
        }
    }
    
    private func clearData() {
        loggedInUser = nil
        
        UserDefaults.standard.set(false, forKey: UserDefaultKey().isLoggedIn)
        UserDefaults.standard.set(false, forKey: UserDefaultKey().isRemeberMe)
        UserDefaults.standard.set("", forKey: kUserCookie)
        UserDefaults.standard.set("", forKey: kUserRememberMe)
        
        let registerOptionsView = UIHostingController(rootView: RegisterOptionsView())
        APP_DELEGATE.window?.rootViewController = registerOptionsView
    }
}
