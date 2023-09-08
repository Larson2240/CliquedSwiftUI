//
//  EmailNotificationsView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 13.08.2023.
//

import SwiftUI

struct EmailNotificationsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            content
        }
        .background(background)
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        VStack() {
            header
            
            list
            
            unsubscribeAllButton
        }
    }
    
    private var header: some View {
        ZStack {
            Text(Constants.labelSettingRowTitle_emailNotifications)
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
        ScrollView {
            rowCell(title: "New Matches", binding: .constant(true))
            
            divider
            
            rowCell(title: "Messages", binding: .constant(true))
            
            divider
            
            rowCell(title: "Promotions", binding: .constant(true))
        }
    }
    
    private func rowCell(title: String, binding: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .font(.themeRegular(12))
                .foregroundColor(.colorDarkGrey)
                .frame(height: 50)
            
            Spacer()
            
            Toggle("", isOn: binding)
                .tint(Color.theme)
        }
        .padding(.horizontal)
    }
    
    private var unsubscribeAllButton: some View {
        Button(action: {  }) {
            ZStack {
                Color.theme
                
                Text(Constants.btn_unsubscribe)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .frame(height: 60)
        .cornerRadius(30)
        .padding(30)
    }
    
    private var divider: some View {
        Divider()
            .padding(.horizontal)
    }
}

struct EmailNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        EmailNotificationsView()
    }
}
