//
//  RelationshipView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 25.05.2023.
//

import SwiftUI

struct RelationshipView: View {
    @StateObject var viewModel = OnboardingViewModel()
    
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
        NavigationLink(destination: RelationshipView(),
                       isActive: $relationshipViewPresented,
                       label: EmptyView.init)
    }
    
    private func onAppearConfig() {
        viewModel.nextAction = {
            relationshipViewPresented.toggle()
        }
    }
    
    private func continueAction() {
        if !viewModel.gender.isEmpty {
            viewModel.profileSetupType = ProfileSetupType().gender
            viewModel.callSignUpProcessAPI()
        } else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_gender)
        }
    }
}

struct RelationshipView_Previews: PreviewProvider {
    static var previews: some View {
        RelationshipView()
    }
}
