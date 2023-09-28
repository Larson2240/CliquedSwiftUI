//
//  WelcomeView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 24.05.2023.
//

import SwiftUI

struct WelcomeView: View {
    @State private var nameViewPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                content
                
                presentables
            }
            .background(background)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack(spacing: 8) {
            HeaderView(title: Constants.screenTitle_welcome,
                       backButtonVisible: false,
                       backAction: {})
            
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
    
    private var continueButton: some View {
        Button(action: { nameViewPresented.toggle() }) {
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
        NavigationLink(destination: NameView(),
                       isActive: $nameViewPresented,
                       label: EmptyView.init)
        .isDetailLink(false)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
