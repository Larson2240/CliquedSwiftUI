//
//  NotificationsView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 02.06.2023.
//

import SwiftUI

struct NotificationsView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel.shared
    @StateObject private var notificationsViewModel = NotificationsViewModel()
    
    @State private var startExploringViewPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                content
                
                presentables
            }
            .background(background)
            .onAppear { onAppearConfig() }
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
    
    private var background: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width: screenSize.width, height: screenSize.height)
    }
    
    private var header: some View {
        HeaderView(title: Constants.screenTitle_notification,
                   backButtonVisible: false)
    }
    
    private var title: some View {
        Text(Constants.label_notificationScreenSubTitle)
            .font(.themeBold(20))
            .foregroundColor(.colorDarkGrey)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.center)
            .padding(.top, 40)
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
                if notificationsViewModel.notificationsEnabled == false {
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
    
    private func onAppearConfig() {
        notificationsViewModel.registerForPushNotifications()
        
        onboardingViewModel.nextAction = {
            
        }
    }
    
    private func continueAction() {
        onboardingViewModel.profileSetupType = ProfileSetupType().completed
        managenotificationValue(typeOfOption: notificationsViewModel.notificationsEnabled == true ? NotificationPermissionTypeIds().Yes : NotificationPermissionTypeIds().No)
        
        UserDefaults.standard.set(true, forKey: UserDefaultKey().isLoggedIn)
        UserDefaults.standard.set(true, forKey: UserDefaultKey().isRemeberMe)
        
        onboardingViewModel.callSignUpProcessAPI()
    }
    
    func managenotificationValue(typeOfOption: String) {
        var arrayOfPreference = [PreferenceClass]()
        var arrayOfTypeOption = [TypeOptions]()
        
        arrayOfPreference = Constants.getPreferenceData?.filter({$0.typesOfPreference == PreferenceTypeIds().notification_enable}) ?? []
        
        if arrayOfPreference.count > 0 {
            arrayOfTypeOption = arrayOfPreference[0].typeOptions ?? []
            if arrayOfTypeOption.count > 0 {
                arrayOfTypeOption = arrayOfTypeOption.filter({$0.typeOfOptions == typeOfOption})
                var dict = NotificationParam()
                dict.notificationPreferenceId = arrayOfTypeOption[0].preferenceId?.description ?? ""
                dict.notificationOptionId = arrayOfTypeOption[0].id?.description ?? ""
                
                onboardingViewModel.notification = dict
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
