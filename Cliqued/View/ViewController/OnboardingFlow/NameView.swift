//
//  NameView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 24.05.2023.
//

import SwiftUI

struct NameView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        content
            .background(background)
            .onAppear { onAppearConfig() }
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private var content: some View {
        VStack(spacing: 30) {
            header
            
            description
            
            Image("ic_registrationlogo")
            
            emailStack
            
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
            Text(Constants.label_name)
                .font(.themeMedium(14))
                .foregroundColor(.colorDarkGrey)
            
            TextField(Constants.label_name, text: $viewModel.name)
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
    
    private var header: some View {
        HeaderView(title: Constants.screenTitle_forgotPwd,
                   backButtonVisible: true)
    }
    
    private var description: some View {
        VStack(spacing: 16) {
            Text(Constants.label_nameScreenTitle)
                .font(.themeMedium(20))
            
            Text(Constants.label_nameScreenSubTitle)
                .font(.themeMedium(14))
        }
        .foregroundColor(.colorDarkGrey)
        .multilineTextAlignment(.center)
    }
    
    private var sendButton: some View {
        Button(action: {  }) {
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
    
    private func onAppearConfig() {
        viewModel.nextAction = {
            
        }
    }
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView()
    }
}
