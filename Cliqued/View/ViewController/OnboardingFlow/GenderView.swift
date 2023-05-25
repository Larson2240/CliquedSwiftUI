//
//  GenderView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 25.05.2023.
//

import SwiftUI

struct GenderView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var viewModel = OnboardingViewModel()
    
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
            
            genderStack
            
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
        HeaderView(title: Constants.screenTitle_gender,
                   backButtonVisible: true)
    }
    
    private var description: some View {
        VStack(spacing: 16) {
            Text(Constants.label_genderScreenTitle)
                .font(.themeBold(20))
            
            Text(Constants.label_genderScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.top, 40)
    }
    
    private var genderStack: some View {
        HStack(spacing: 16) {
            genderOption(icon: "ic_female_black", title: Constants.btn_female, isSelected: viewModel.gender == Constants.btn_female)
            
            genderOption(icon: "ic_male_black", title: Constants.btn_male, isSelected: viewModel.gender == Constants.btn_male)
        }
        .padding(.horizontal)
    }
    
    private func genderOption(
        icon: String,
        title: String,
        isSelected: Bool
    ) -> some View {
        Button(action: { viewModel.gender = title }) {
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
                    
                    Text(title)
                        .font(.themeMedium(18))
                        .foregroundColor(isSelected ? .white : .colorDarkGrey)
                }
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

struct GenderView_Previews: PreviewProvider {
    static var previews: some View {
        GenderView()
    }
}
