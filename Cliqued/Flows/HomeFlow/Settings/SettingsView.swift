//
//  SettingsView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 08.08.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
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
            rowTitle(text: Constants.label_email)
            
            rowTitle(text: Constants.label_password)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_accountSetting)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var subscription: some View {
        Section {
            rowTitle(text: Constants.labelSettingRowTitle_inAppPurchase)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_subscription, basicAccount: true)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var connections: some View {
        Section {
            rowTitle(text: Constants.labelSettingRowTitle_blockedContacts)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_connections)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var activeStatus: some View {
        Section {
            rowTitle(text: Constants.labelSettingRowTitle_onlineNow)
            
            rowTitle(text: Constants.labelSettingRowTitle_lastSeenStatus)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_activeStatus)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var notifications: some View {
        Section {
            rowTitle(text: Constants.labelSettingRowTitle_emailNotifications)
            
            rowTitle(text: Constants.labelSettingRowTitle_pushNotifications)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_notifications)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var otherSettings: some View {
        Section {
            rowTitle(text: Constants.labelSettingRowTitle_restorePurchase)
            
            rowTitle(text: Constants.labelSettingRowTitle_inviteFriends)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_otherSettings)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var contactUs: some View {
        Section {
            rowTitle(text: Constants.labelSettingSectionTitle_contactUs)
        } header: {
            sectionHeader(text: Constants.labelSettingSectionTitle_contactUs)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var guidelines: some View {
        Section {
            rowTitle(text: Constants.labelSettingRowTitle_communityGuidelines)
            
            rowTitle(text: Constants.labelSettingRowTitle_safetyTips)
        } header: {
            sectionHeader(text: Constants.labelSettingRowTitle_communityGuidelines)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var privacyPolicy: some View {
        Section {
            rowTitle(text: Constants.labelSettingRowTitle_cookiePolicy)
            
            rowTitle(text: Constants.labelSettingRowTitle_privacyPolicy)
        } header: {
            sectionHeader(text: Constants.labelSettingRowTitle_privacyPolicy)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
    private var legal: some View {
        Section {
            rowTitle(text: Constants.labelSettingRowTitle_termsOfService)
            
            rowTitle(text: Constants.labelSettingRowTitle_licenses)
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
    
    private func rowTitle(text: String) -> some View {
        Text(text)
            .font(.themeRegular(12))
            .foregroundColor(.colorDarkGrey)
            .padding(.horizontal)
            .frame(height: 50)
    }
    
    private var bottomButtons: some View {
        VStack {
            Text(Constants_Message.title_delete_account)
                .font(.themeBold(16))
                .foregroundColor(.theme)
            
            Button(action: {  }) {
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
