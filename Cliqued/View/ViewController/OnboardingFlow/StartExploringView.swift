//
//  StartExploringView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 03.06.2023.
//

import SwiftUI

struct StartExploringView: View {
    var body: some View {
        NavigationView {
            ZStack {
                content
            }
            .background(background)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            header
            
            title
            
            Image("ic_splash_icon")
                .padding(.top, 60)
            
            Spacer()
            
            startExploringButton
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
        HeaderView(title: Constants.screenTitle_notification,
                   backButtonVisible: false)
    }
    
    private var title: some View {
        VStack {
            Text("Hi \(Constants.loggedInUser?.name ?? "")!")
                .font(.themeBold(30))
                .foregroundColor(.colorDarkGrey)
                .multilineTextAlignment(.center)
                .padding(.top, 40)
                .padding(.horizontal)
            
            Text(Constants.label_startExploringSubTitle)
                .font(.themeBook(14))
                .foregroundColor(.colorDarkGrey)
        }
    }
    
    private var startExploringButton: some View {
        Button(action: { continueAction() }) {
            ZStack {
                Color.theme
                
                Text(Constants.btn_startExploring)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .frame(height: 60)
        .cornerRadius(30)
        .padding(.horizontal, 30)
        .padding(.bottom, 30)
        .padding(.top, 16)
    }
    
    private func continueAction() {
        let tabbarvc = TabBarVC.loadFromNib()
        tabbarvc.selectedIndex = 0
        APP_DELEGATE.window?.rootViewController = UINavigationController(rootViewController: tabbarvc)
    }
}

struct StartExploringView_Previews: PreviewProvider {
    static var previews: some View {
        StartExploringView()
    }
}
