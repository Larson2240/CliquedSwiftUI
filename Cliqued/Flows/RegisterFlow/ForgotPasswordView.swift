//
//  ForgotPasswordView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 24.05.2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = ForgotPasswordViewModel()
    
    var body: some View {
        content
            .background(background)
            .navigationBarHidden(true)
            .onAppear {
                viewModel.dismissAction = { message in
                    UIApplication.shared.showAlerBox("", message) { _ in
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private var content: some View {
        VStack(spacing: 30) {
            header
            
            description
            
            Image("ic_registrationlogo")
            
            Spacer()
            
            emailStack
            
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
    
    private var emailStack: some View {
        VStack(alignment: .leading, spacing: scaled(14)) {
            Text(Constants.label_email)
                .font(.themeMedium(14))
                .foregroundColor(.colorDarkGrey)
            
            HStack(spacing: 12) {
                Image("ic_email")
                
                TextField(Constants.label_email, text: $viewModel.email)
                    .font(.themeMedium(16))
                    .foregroundColor(.colorDarkGrey)
                    .accentColor(.theme)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
            
            Color.colorLightGrey
                .frame(height: 1)
        }
        .padding(.horizontal, 30)
    }
    
    private var header: some View {
        HeaderView(title: Constants.screenTitle_forgotPwd,
                   backButtonVisible: true,
                   backAction: { presentationMode.wrappedValue.dismiss() })
    }
    
    private var description: some View {
        Text(Constants.label_ForgotPwdScreenDescription)
            .font(.themeMedium(14))
            .foregroundColor(.colorDarkGrey)
            .multilineTextAlignment(.center)
    }
    
    private var sendButton: some View {
        Button(action: { viewModel.callForgotPasswordAPI() }) {
            ZStack {
                Color.theme
                
                Text(Constants.btn_send)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .frame(height: 60)
        .cornerRadius(30)
        .padding(30)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
