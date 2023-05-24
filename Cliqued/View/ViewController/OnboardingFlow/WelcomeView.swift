//
//  WelcomeView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 24.05.2023.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    
    var body: some View {
        NavigationView {
            content
                .navigationBarHidden(true)
        }
        .onAppear { viewModel.viewAppeared() }
        .background(background)
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        VStack(spacing: 8) {
            HeaderView(title: Constants.screenTitle_welcome,
                       backButtonVisible: false)
            
            Spacer()
            
            Image("ic_splash_icon")
            
            Text(Constants.label_appWelcomeTitle)
                .font(.themeBold(30))
                .foregroundColor(.colorDarkGrey)
            
            Text(Constants.label_appWelcomeSubTitle)
                .font(.themeBook(14))
                .foregroundColor(.colorDarkGrey)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            continueButton
        }
    }
    
    private var background: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .frame(width: screenSize.width, height: screenSize.height)
            .ignoresSafeArea()
    }
    
    private var continueButton: some View {
        Button(action: { viewModel.callGetUserDetailsAPI() }) {
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
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
