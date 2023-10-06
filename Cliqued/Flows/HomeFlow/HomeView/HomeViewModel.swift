//
//  HomeViewModel.swift
//  Cliqued
//
//  Created by C211 on 17/01/23.
//

import SwiftUI
import UserNotifications

final class HomeViewModel: ObservableObject {
    private func checkPushNotificationEnabled() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { [weak self] settings in
            if settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    APP_DELEGATE.registerForPushNotifications()
                }
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                APP_DELEGATE.registerForPushNotifications()
            }
        })
    }
}
