//
//  NameView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 24.05.2023.
//

import SwiftUI

struct NameView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name = ""
    @State private var ageViewPresented = false
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
        .background(background)
        .onAppear { prefillNameForSocialLoginUser() }
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        VStack(spacing: 30) {
            header
            
            description
            
            Spacer()
            
            emailStack
            
            Spacer()
            Spacer()
            
            continueButton
        }
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.label_name,
                       backButtonVisible: false,
                       backAction: {})
            
            OnboardingProgressView(totalSteps: 9, currentStep: 1)
        }
    }
    
    private var description: some View {
        VStack(spacing: 12) {
            Text(Constants.label_nameScreenTitle)
                .font(.themeBold(20))
            
            Text(Constants.label_nameScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.top, scaled(60))
        .padding(.horizontal)
    }
    
    private var emailStack: some View {
        VStack(alignment: .leading, spacing: scaled(14)) {
            Text(Constants.label_name)
                .font(.themeMedium(14))
                .foregroundColor(.colorDarkGrey)
            
            TextField(Constants.label_name, text: $name)
                .font(.themeMedium(16))
                .foregroundColor(.colorDarkGrey)
                .accentColor(.theme)
                .autocorrectionDisabled()
                .autocapitalization(.none)
            
            Color.colorLightGrey
                .frame(height: 1)
        }
        .padding(.horizontal, 30)
    }
    
    private var continueButton: some View {
        Button(action: { continueAction() }) {
            ZStack {
                Color.theme
                
                Text(Constants.btn_continue)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .frame(height: 60)
        .cornerRadius(30)
        .padding(30)
    }
    
    private var presentables: some View {
        NavigationLink(destination: AgeView(),
                       isActive: $ageViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func prefillNameForSocialLoginUser() {
        let userName = UserDefaults.standard.string(forKey: UserDefaultKey().userName)
        name = userName ?? ""
    }
    
    private func continueAction() {
        guard name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_name)
            return
        }
        
        guard isOnlyCharacter(text: name) else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_validName)
            return
        }
        
        guard var user = Constants.loggedInUser else { return }
        
        user.name = name
        Constants.saveUser(user: user)
        ageViewPresented.toggle()
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView()
    }
}
