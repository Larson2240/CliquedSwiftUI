//
//  SettingsView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 08.08.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        VStack() {
            header
            
            list
            
            bottomButtons
        }
    }
    
    private var header: some View {
        ZStack {
            Text(Constants.screenTitle_settings)
                .font(.themeBold(16))
                .foregroundColor(.colorSenderTextMsg)
            
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image("ic_back_black")
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    private var list: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                accountSettings
                
                subscription
                
                connections
                
                activeStatus
                
                notifications
                
                otherSettings
                
                contactUs
                
                guidelines
                
                privacyPolicy
                
                legal
            }
        }
    }
    
    private var accountSettings: some View {
        Section {
            row(text: Constants.label_email, chevronVisible: false)
            
            row(text: Constants.label_password, chevronVisible: false)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_accountSetting)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var subscription: some View {
        Section {
            row(text: Constants.labelSettingRowTitle_inAppPurchase, chevronVisible: false)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_subscription, basicAccount: true)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var connections: some View {
        Section {
            row(text: Constants.labelSettingRowTitle_blockedContacts, chevronVisible: false)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_connections)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var activeStatus: some View {
        Section {
            HStack {
                Text(Constants.labelSettingRowTitle_onlineNow)
                    .font(.themeRegular(12))
                    .foregroundColor(.colorDarkGrey)
                    .frame(height: 50)
                
                Spacer()
                
                Toggle("", isOn: .constant(true))
                    .tint(Color.theme)
            }
            .padding(.horizontal)
            
            HStack {
                Text(Constants.labelSettingRowTitle_lastSeenStatus)
                    .font(.themeRegular(12))
                    .foregroundColor(.colorDarkGrey)
                    .frame(height: 50)
                
                Spacer()
                
                Toggle("", isOn: .constant(true))
                    .tint(Color.theme)
            }
            .padding(.horizontal)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_activeStatus)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var notifications: some View {
        Section {
            row(text: Constants.labelSettingRowTitle_emailNotifications, chevronVisible: false)
            
            row(text: Constants.labelSettingRowTitle_pushNotifications, chevronVisible: false)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_notifications)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var otherSettings: some View {
        Section {
            row(text: Constants.labelSettingRowTitle_restorePurchase, chevronVisible: false)
            
            row(text: Constants.labelSettingRowTitle_inviteFriends, chevronVisible: false)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_otherSettings)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var contactUs: some View {
        Section {
            row(text: Constants.labelSettingSectionTitle_contactUs, chevronVisible: false)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_contactUs)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var guidelines: some View {
        Section {
            row(text: Constants.labelSettingRowTitle_communityGuidelines, chevronVisible: false)
            
            row(text: Constants.labelSettingRowTitle_safetyTips, chevronVisible: false)
        } header: {
            sectionHeader(text: Constants.labelSettingRowTitle_communityGuidelines)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var privacyPolicy: some View {
        Section {
            row(text: Constants.labelSettingRowTitle_cookiePolicy, chevronVisible: false)
            
            row(text: Constants.labelSettingRowTitle_privacyPolicy, chevronVisible: false)
        } header: {
            sectionHeader(text: Constants.labelSettingRowTitle_privacyPolicy)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var legal: some View {
        Section {
            row(text: Constants.labelSettingRowTitle_termsOfService, chevronVisible: false)
            
            row(text: Constants.labelSettingRowTitle_licenses, chevronVisible: false)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_legal)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private func sectionHeader(text: String, basicAccount: Bool = false) -> some View {
        ZStack {
            Color(hex: "FFF4E8")
                .frame(height: 40)
            
            HStack {
                Text(text)
                    .font(.themeBold(14))
                    .foregroundColor(.colorDarkGrey)
                
                Spacer()
                
                if basicAccount {
                    Text("Basic Account")
                        .font(.themeMedium(14))
                        .foregroundColor(.theme)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func row(text: String, chevronVisible: Bool) -> some View {
        HStack {
            Text(text)
                .font(.themeRegular(12))
                .foregroundColor(.colorDarkGrey)
                .frame(height: 50)
            
            Image("ic_next_arrow")
        }
        .padding(.horizontal)
    }
    
    private var bottomButtons: some View {
        VStack {
            Button(action: { viewModel.deleteAccount() }) {
                Text(Constants_Message.title_delete_account)
                    .font(.themeBold(16))
                    .foregroundColor(.theme)
            }
            
            Button(action: { viewModel.logout() }) {
                ZStack {
                    Color.theme
                    
                    Text(Constants.btn_logout)
                        .font(.themeBold(20))
                        .foregroundColor(.colorWhite)
                }
            }
            .frame(height: 60)
            .cornerRadius(30)
            .padding(.horizontal, 30)
            .padding(.bottom)
        }
    }
    
    private var presentables: some View {
        ZStack {
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
