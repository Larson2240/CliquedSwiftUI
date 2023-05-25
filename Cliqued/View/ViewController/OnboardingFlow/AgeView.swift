//
//  AgeView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 25.05.2023.
//

import SwiftUI

struct AgeView: View {
    @StateObject var viewModel = OnboardingViewModel()
    
    @State private var date = Date()
    @State private var genderViewPresented = false
    
    private let minAge: Date = Calendar.current.date(byAdding: .year, value: -45, to: Date())!
    private let maxAge: Date = Calendar.current.date(byAdding: .year, value: -150, to: Date())!
    
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
            
            dateStack
            
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
        HeaderView(title: Constants.screenTitle_age,
                   backButtonVisible: true)
    }
    
    private var description: some View {
        VStack(spacing: 16) {
            Text(title())
                .font(.themeBold(20))
            
            Text(Constants.label_ageScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.top, 40)
        .padding(.horizontal)
    }
    
    private var dateStack: some View {
        DatePicker("", selection: $date, displayedComponents: .date)
            .datePickerStyle(.wheel)
            .padding(.horizontal, 30)
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
        NavigationLink(destination: GenderView(),
                       isActive: $genderViewPresented,
                       label: EmptyView.init)
    }
    
    private func onAppearConfig() {
        viewModel.nextAction = {
            genderViewPresented.toggle()
        }
    }
    
    private func title() -> String {
        return "\(Constants.label_ageScreenTitleBeforName) \(viewModel.name) \(Constants.label_ageScreenTitleAfterName)"
    }
    
    private func continueAction() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let isValidAge = validateAge(birthDate: date)
        viewModel.dateOfBirth = dateFormatter.string(from: date)
        
        if isValidAge {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_age)
        } else {
            viewModel.profileSetupType = ProfileSetupType().birthdate
            viewModel.callSignUpProcessAPI()
        }
    }
    
    func validateAge(birthDate: Date) -> Bool {
        var isValid = true
        
        if birthDate >= maxAge && birthDate <= minAge {
            isValid = false
        }
        
        return isValid
    }
}

struct AgeView_Previews: PreviewProvider {
    static var previews: some View {
        AgeView()
    }
}
