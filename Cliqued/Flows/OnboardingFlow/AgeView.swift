//
//  AgeView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 25.05.2023.
//

import SwiftUI

struct AgeView: View {
    @State private var date = Date()
    @State private var genderViewPresented = false
    
    @AppStorage("loggedInUser") var loggedInUser: User? = nil
    
    private let minAge: Date = Calendar.current.date(byAdding: .year, value: -45, to: Date())!
    private let maxAge: Date = Calendar.current.date(byAdding: .year, value: -150, to: Date())!
    
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
            
            dateStack
            
            Spacer()
            Spacer()
            
            continueButton
        }
    }
    
    private var header: some View {
        VStack(spacing: 20) {
            HeaderView(title: Constants.screenTitle_age,
                       backButtonVisible: false,
                       backAction: {})
            
            OnboardingProgressView(totalSteps: 9, currentStep: 2)
        }
    }
    
    private var description: some View {
        VStack(spacing: 12) {
            Text(title())
                .font(.themeBold(20))
            
            Text(Constants.label_ageScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
        .padding(.top, scaled(60))
        .padding(.horizontal)
    }
    
    private var dateStack: some View {
        DatePicker("", selection: $date, displayedComponents: .date)
            .datePickerStyle(.wheel)
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
        NavigationLink(destination: GenderView(),
                       isActive: $genderViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
    
    private func title() -> String {
        return "\(Constants.label_ageScreenTitleBeforName) \(loggedInUser?.name ?? "") \(Constants.label_ageScreenTitleAfterName)"
    }
    
    private func continueAction() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard validateAge(birthDate: date) else {
            UIApplication.shared.showAlertPopup(message: Constants.validMsg_age)
            return
        }
        
        loggedInUser?.birthdate = dateFormatter.string(from: date)
        genderViewPresented.toggle()
    }
    
    func validateAge(birthDate: Date) -> Bool {
        var isValid = false
        
        if birthDate >= maxAge && birthDate <= minAge {
            isValid = true
        }
        
        return isValid
    }
}

struct AgeView_Previews: PreviewProvider {
    static var previews: some View {
        AgeView()
    }
}
