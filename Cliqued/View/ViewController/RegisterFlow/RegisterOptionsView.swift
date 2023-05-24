//
//  RegisterOptionsView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 21.05.2023.
//

import SwiftUI

struct RegisterOptionsView: View {
    @State private var signUpViewPresented = false
    @State private var signInViewPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                background
                
                content
                
                presentables
            }
            .navigationBarHidden(true)
        }
    }
    
    private var content: some View {
        VStack(spacing: 12) {
            Image("ic_welcome_icon")
            
            Spacer()
            
            option(text: Constants.btn_signUp,
                   textColor: .colorWhite,
                   color: .theme) {
                signUpViewPresented.toggle()
            }
            
            option(text: Constants.btn_logIn,
                   textColor: .colorDarkGrey,
                   color: .colorLightGrey) {
                signInViewPresented.toggle()
            }
        }
        .padding(.vertical, 100)
    }
    
    private var background: some View {
        Image("welcome_bkg")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width: screenSize.width, height: screenSize.height)
    }
    
    private var presentables: some View {
        ZStack {
            NavigationLink(destination: SignUpView(currentFlow: .signUp),
                           isActive: $signUpViewPresented,
                           label: EmptyView.init)
            
            NavigationLink(destination: SignUpView(currentFlow: .signIn),
                           isActive: $signInViewPresented,
                           label: EmptyView.init)
        }
    }
    
    private func option(
        text: String,
        textColor: Color,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            ZStack {
                color
                
                Text(text)
                    .font(.themeBold(20))
                    .foregroundColor(textColor)
            }
        }
        .frame(height: 60)
        .cornerRadius(30)
        .padding(.horizontal, 50)
    }
}

struct RegisterOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterOptionsView()
    }
}
