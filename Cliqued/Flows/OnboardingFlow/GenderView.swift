//
//  GenderView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 25.05.2023.
//

import SwiftUI

struct GenderView: View {
    @State private var gender: Int? = nil
    @State private var relationshipViewPresented = false
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
        .background(background)
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        VStack(spacing: 30) {
            header
            
            description
            
            Spacer()
            
            genderStack
            
            Spacer()
            Spacer()
            
            continueButton
        }
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.screenTitle_gender,
                       backButtonVisible: false,
                       backAction: {})
            
            OnboardingProgressView(totalSteps: 9, currentStep: 3)
        }
    }
    
    private var description: some View {
        VStack(spacing: 12) {
            Text(Constants.label_genderScreenTitle)
                .font(.themeBold(20))
            
            Text(Constants.label_genderScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.top, scaled(60))
        .padding(.horizontal)
    }
    
    private var genderStack: some View {
        HStack(spacing: 16) {
            genderOption(icon: "ic_female_black", title: Constants.btn_female, gender: 2)
            
            genderOption(icon: "ic_male_black", title: Constants.btn_male, gender: 1)
        }
        .padding(.horizontal)
    }
    
    private func genderOption(icon: String, title: String, gender: Int) -> some View {
        Button(action: { self.gender = gender }) {
            ZStack {
                if self.gender == gender {
                    Color.colorGreenSelected
                } else {
                    Color.colorLightGrey
                }
                
                HStack {
                    Image(icon)
                        .renderingMode(.template)
                        .foregroundColor(self.gender == gender ? .white : .colorDarkGrey)
                    
                    Text(title)
                        .font(.themeMedium(18))
                        .foregroundColor(self.gender == gender ? .white : .colorDarkGrey)
                }
            }
        }
        .frame(height: 50)
        .cornerRadius(10)
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
        NavigationLink(destination: RelationshipView(isFromEditProfile: false),
                       isActive: $relationshipViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func continueAction() {
        guard let gender = gender else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_gender)
            return
        }
        
        guard var user = Constants.loggedInUser else { return }
        
        user.gender = gender
        Constants.saveUser(user: user)
        relationshipViewPresented.toggle()
    }
}

struct GenderView_Previews: PreviewProvider {
    static var previews: some View {
        GenderView()
    }
}
