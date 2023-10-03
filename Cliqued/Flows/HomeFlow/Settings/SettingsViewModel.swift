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
    
    func logout() {
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        authWebService.logout { result in
            UIApplication.shared.hideLoader()
            
            switch result {
            case .success:
                UserDefaults.standard.set(false, forKey: UserDefaultKey().isLoggedIn)
                UserDefaults.standard.set(false, forKey: UserDefaultKey().isRemeberMe)
                
                let registerOptionsView = UIHostingController(rootView: RegisterOptionsView())
                APP_DELEGATE.window?.rootViewController = registerOptionsView
            case .failure(let error):
                UIApplication.shared.showAlertPopup(message: error.localizedDescription)
            }
        }
    }
    
    func deleteAccount() {
        guard Connectivity.isConnectedToInternet() else {
            UIApplication.shared.showAlertPopup(message: Constants.alert_InternetConnectivity)
            return
        }
        
        UIApplication.shared.showLoader()
        
        userWebService.deleteUser { result in
            UIApplication.shared.hideLoader()
            
            switch result {
            case .success:
                UserDefaults.standard.set(false, forKey: UserDefaultKey().isLoggedIn)
                UserDefaults.standard.set(false, forKey: UserDefaultKey().isRemeberMe)
                
                let registerOptionsView = UIHostingController(rootView: RegisterOptionsView())
                APP_DELEGATE.window?.rootViewController = registerOptionsView
            case .failure(let error):
                UIApplication.shared.showAlertPopup(message: error.localizedDescription)
            }
        }
    }
}
