//
//  RelationshipView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 25.05.2023.
//

import SwiftUI

struct RelationshipView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var isFromEditProfile: Bool
    
    @State private var romancePreference: Int?
    @State private var friendshipPreference: Int?
    
    @State private var activityViewPresented = false
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
        .background(background)
        .onAppear {
            romancePreference = Constants.loggedInUser?.preferenceRomance
            friendshipPreference = Constants.loggedInUser?.preferenceFriendship
        }
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        VStack(spacing: 30) {
            header
            
            description
            
            Spacer()
            
            romanceStack
            
            friendshipStack
            
            Spacer()
            Spacer()
            
            continueButton
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.screenTitle_relationship,
                       backButtonVisible: isFromEditProfile,
                       backAction: { presentationMode.wrappedValue.dismiss() })
            
            if !isFromEditProfile {
                OnboardingProgressView(totalSteps: 9, currentStep: 4)
            }
        }
    }
    
    private var description: some View {
        VStack(spacing: 12) {
            Text(Constants.label_relationshipScreenTitle)
                .font(.themeBold(20))
            
            Text(Constants.label_relationshipScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.top, scaled(60))
        .padding(.horizontal)
    }
    
    private var romanceStack: some View {
        HStack(spacing: 12) {
            buble(icon: "ic_romance_black",
                  text: Constants.btn_romance,
                  isSelected: romancePreference != nil)
            
            Text(Constants.label_with)
                .font(.themeMedium(15))
                .foregroundColor(.colorDarkGrey)
            
            option(title: Constants.btn_female, isSelected: romancePreference == 2 || romancePreference == 3) {
                if romancePreference == nil {
                    romancePreference = 2
                } else if romancePreference == 1 {
                    romancePreference = 3
                } else if romancePreference == 2 {
                    romancePreference = nil
                } else if romancePreference == 3 {
                    romancePreference = 1
                }
            }
            
            option(title: Constants.btn_male, isSelected: romancePreference == 1 || romancePreference == 3) {
                if romancePreference == nil {
                    romancePreference = 1
                } else if romancePreference == 2 {
                    romancePreference = 3
                } else if romancePreference == 1 {
                    romancePreference = nil
                } else if romancePreference == 3 {
                    romancePreference = 2
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var friendshipStack: some View {
        HStack(spacing: 12) {
            buble(icon: "ic_friendship_black",
                  text: Constants.btn_friendship,
                  isSelected: friendshipPreference != nil)
            
            Text(Constants.label_with)
                .font(.themeMedium(15))
                .foregroundColor(.colorDarkGrey)
            
            option(title: Constants.btn_female, isSelected: friendshipPreference == 2 || friendshipPreference == 3) {
                if friendshipPreference == nil {
                    friendshipPreference = 2
                } else if friendshipPreference == 1 {
                    friendshipPreference = 3
                } else if friendshipPreference == 2 {
                    friendshipPreference = nil
                } else if friendshipPreference == 3 {
                    friendshipPreference = 1
                }
            }
            
            option(title: Constants.btn_male, isSelected: friendshipPreference == 1 || friendshipPreference == 3) {
                if friendshipPreference == nil {
                    friendshipPreference = 1
                } else if friendshipPreference == 2 {
                    friendshipPreference = 3
                } else if friendshipPreference == 1 {
                    friendshipPreference = nil
                } else if friendshipPreference == 3 {
                    friendshipPreference = 2
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func buble(
        icon: String,
        text: String,
        isSelected: Bool
    ) -> some View {
        ZStack {
            if isSelected {
                Color.colorGreenSelected
            } else {
                Color.colorLightGrey
            }
            
            HStack {
                Image(icon)
                    .renderingMode(.template)
                    .foregroundColor(isSelected ? .white : .colorDarkGrey)
                
                Text(text)
                    .font(.themeMedium(15))
                    .foregroundColor(isSelected ? .white : .colorDarkGrey)
            }
        }
        .cornerRadius(10)
        .frame(width: 130, height: 50)
    }
    
    private func option(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    Color.colorGreenSelected
                } else {
                    Color.colorLightGrey
                }
                
                Text(title)
                    .font(.themeMedium(15))
                    .foregroundColor(isSelected ? .white : .colorDarkGrey)
            }
        }
        .frame(width: 75, height: 50)
        .cornerRadius(10)
    }
    
    private var continueButton: some View {
        Button(action: { continueAction() }) {
            ZStack {
                if romancePreference == nil && friendshipPreference == nil {
                    Color.gray
                } else {
                    Color.theme
                }
                
                Text(Constants.btn_continue)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .cornerRadius(30)
        .frame(height: 60)
        .disabled(romancePreference == nil && friendshipPreference == nil)
        .padding(.horizontal, 30)
        .padding(.bottom, safeAreaInsets.bottom == 0 ? 16 : safeAreaInsets.bottom)
    }
    
    private var presentables: some View {
        NavigationLink(destination: PickActivityView(isFromEditProfile: false, arrayOfActivity: [], activitiesFlowPresented: .constant(false)),
                       isActive: $activityViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func continueAction() {
        guard var user = Constants.loggedInUser else { return }
        
        user.preferenceRomance = romancePreference
        user.preferenceFriendship = friendshipPreference
        
        Constants.saveUser(user: user)
        activityViewPresented.toggle()
    }
}

struct RelationshipView_Previews: PreviewProvider {
    static var previews: some View {
        RelationshipView(isFromEditProfile: false)
    }
}
