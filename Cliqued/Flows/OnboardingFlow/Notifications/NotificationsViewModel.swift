//
//  NotificationsViewModel.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 03.06.2023.
//

import Combine
import UserNotifications

final class NotificationsViewModel: NSObject, ObservableObject {
    @Published var notificationsEnabled: Bool?
    
    override init() {
        super.init()
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async { [weak self] in
                self?.notificationsEnabled = granted
            }
        }
    }
    
    func checkNotificationsPermission() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { [weak self] permission in
            guard let self = self else { return }
            
            switch permission.authorizationStatus  {
            case .authorized:
                self.notificationsEnabled = true
            case .denied:
                self.notificationsEnabled = false
            case .notDetermined:
                print("Notification permission haven't been asked yet")
            case .provisional:
                // @available(iOS 12.0, *)
                print("The application is authorized to post non-interruptive user notifications.")
            case .ephemeral:
                // @available(iOS 14.0, *)
                print("The application is temporarily authorized to post notifications. Only available to app clips.")
            @unknown default:
                print("Unknow Status")
            }
        })
    }
}

extension NotificationsViewModel: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device Token: \(deviceTokenString)")
        UserDefaults.standard.set(deviceTokenString, forKey: kDeviceToken)
    }
    
    func application(_ application: UIApplication,didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        let data = response.notification.request.content.userInfo
    }
}
