//
//  RelationshipView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 25.05.2023.
//

import SwiftUI

struct RelationshipView: View {
    @StateObject var viewModel = OnboardingViewModel()
    var isFromEditProfile: Bool
    var arrayOfUserPreference: [UserPreferences]?
    
    @State private var friendshipWithMenSelected = false
    @State private var friendshipWithWomanSelected = false
    @State private var romanceWithMenSelected = false
    @State private var romanceWithWomanSelected = false
    
    @State private var relationshipViewPresented = false
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
        .background(background)
        .onAppear { onAppearConfig() }
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
            
            sendButton
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
        HeaderView(title: Constants.screenTitle_relationship,
                   backButtonVisible: true)
    }
    
    private var description: some View {
        VStack(spacing: 16) {
            Text(Constants.label_relationshipScreenTitle)
                .font(.themeBold(20))
            
            Text(Constants.label_relationshipScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.top, 40)
        .padding(.horizontal)
    }
    
    private var romanceStack: some View {
        HStack(spacing: 12) {
            buble(icon: "ic_romance_black",
                  text: Constants.btn_romance,
                  isSelected: romanceWithMenSelected || romanceWithWomanSelected)
            
            Text(Constants.label_with)
                .font(.themeMedium(15))
                .foregroundColor(.colorDarkGrey)
            
            option(title: Constants.btn_female, isSelected: romanceWithWomanSelected) {
                romanceWithWomanSelected.toggle()
            }
            
            option(title: Constants.btn_male, isSelected: romanceWithMenSelected) {
                romanceWithMenSelected.toggle()
            }
        }
        .padding(.horizontal)
    }
    
    private var friendshipStack: some View {
        HStack(spacing: 16) {
            buble(icon: "ic_friendship_black",
                  text: Constants.btn_friendship,
                  isSelected: friendshipWithMenSelected || friendshipWithWomanSelected)
            
            Text(Constants.label_with)
                .font(.themeMedium(15))
                .foregroundColor(.colorDarkGrey)
            
            option(title: Constants.btn_female, isSelected: friendshipWithWomanSelected) {
                friendshipWithWomanSelected.toggle()
            }
            
            option(title: Constants.btn_male, isSelected: friendshipWithMenSelected) {
                friendshipWithMenSelected.toggle()
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
        .frame(height: 50)
        .cornerRadius(10)
    }
    
    private var sendButton: some View {
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
        ZStack {
            
        }
    }
    
    private func onAppearConfig() {
        viewModel.nextAction = {
//            if !isFromEditProfile {
//                let pickactivityVC = PickActivityVC.loadFromNib()
//                navigationController?.pushViewController(pickactivityVC, animated: true)
//            } else {
//                NotificationCenter.default.post(name: Notification.Name("refreshProfileData"), object: nil, userInfo: nil)
//                let editprofilevc = EditProfileVC.loadFromNib()
//                editprofilevc.isUpdateData = true
//                navigationController?.pushViewController(editprofilevc, animated: true)
//            }
            
            relationshipViewPresented.toggle()
        }
    }
    
    private func continueAction() {
        if !isFromEditProfile {
            viewModel.profileSetupType = ProfileSetupType().relationship
        } else {
            viewModel.profileSetupType = ProfileSetupType().completed
        }
        
        guard !viewModel.arrayRelationshipParam.isEmpty else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_relationship)
            return
        }
        
        if romanceWithMenSelected {
            viewModel.arrayRelationshipParam.append(RelationshipParam(preference_id: "1", preference_option_id: "2", user_preference_id: "0"))
        }
        
        if romanceWithWomanSelected {
            viewModel.arrayRelationshipParam.append(RelationshipParam(preference_id: "1", preference_option_id: "1", user_preference_id: "0"))
        }
        
        if friendshipWithMenSelected {
            viewModel.arrayRelationshipParam.append(RelationshipParam(preference_id: "2", preference_option_id: "24", user_preference_id: "0"))
        }
        
        if friendshipWithWomanSelected {
            viewModel.arrayRelationshipParam.append(RelationshipParam(preference_id: "2", preference_option_id: "23", user_preference_id: "0"))
        }
        
        viewModel.callSignUpProcessAPI()
    }
}

struct RelationshipView_Previews: PreviewProvider {
    static var previews: some View {
        RelationshipView(isFromEditProfile: false)
    }
}
