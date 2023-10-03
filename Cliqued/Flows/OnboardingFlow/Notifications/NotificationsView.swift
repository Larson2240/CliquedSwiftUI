//
//  NotificationsView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 02.06.2023.
//

import SwiftUI

struct NotificationsView: View {
    @StateObject private var notificationsViewModel = NotificationsViewModel()
    
    @State private var startExploringViewPresented = false
    private let userWebService = UserWebService()
    
    var body: some View {
        NavigationView {
            ZStack {
                content
                
                presentables
            }
            .background(background)
            .onAppear { notificationsViewModel.registerForPushNotifications() }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification).map { _ in }, perform: {
            notificationsViewModel.checkNotificationsPermission()
        })
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            header
            
            title
            
            optionsStack
            
            Spacer()
            
            saveButton
        }
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.screenTitle_notification,
                       backButtonVisible: false,
                       backAction: {})
            
            OnboardingProgressView(totalSteps: 9, currentStep: 9)
        }
    }
    
    private var title: some View {
        Text(Constants.label_notificationScreenSubTitle)
            .font(.themeBold(20))
            .foregroundColor(.colorDarkGrey)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
    
    private var optionsStack: some View {
        VStack {
            option(text: Constants.btn_enableNotification, isSelected: notificationsViewModel.notificationsEnabled == true) {
                if notificationsViewModel.notificationsEnabled == false, let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
            
            option(text: Constants.btn_disableNotification, isSelected: notificationsViewModel.notificationsEnabled == false) {
                if notificationsViewModel.notificationsEnabled == true {
                    UIApplication.shared.alertCustom(btnNo: Constants.btn_cancel, btnYes: Constants.btn_disable, title: Constants.label_notificationDisableTitle, message: Constants.label_notificationDisableMessage) {
                        notificationsViewModel.notificationsEnabled = false
                    }
                }
            }
        }
        .padding(.top)
    }
    
    private func option(text: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                isSelected ? Color.colorGreenSelected : Color.colorLightGrey
                
                Text(text)
                    .font(.themeMedium(15))
                    .foregroundColor(isSelected ? .white : .colorDarkGrey)
            }
            .cornerRadius(8)
            .frame(width: 220, height: 50)
        }
    }
    
    private var saveButton: some View {
        Button(action: { continueAction() }) {
            ZStack {
                Color.theme
                
                Text(Constants.btn_saveProfile)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .frame(height: 60)
        .cornerRadius(30)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
        .padding(.top, 16)
    }
    
    private var presentables: some View {
        NavigationLink(destination: StartExploringView(),
                       isActive: $startExploringViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func continueAction() {
        guard var user = Constants.loggedInUser else { return }
        user.profileSetupType = 10
        Constants.saveUser(user: user)
        
        userWebService.updateUser(user: user) { result in
            switch result {
            case .success:
                UserDefaults.standard.set(true, forKey: UserDefaultKey().isLoggedIn)
                UserDefaults.standard.set(true, forKey: UserDefaultKey().isRemeberMe)
                
                startExploringViewPresented.toggle()
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
