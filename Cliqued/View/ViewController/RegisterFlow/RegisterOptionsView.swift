//
//  RegisterOptionsView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 21.05.2023.
//

import SwiftUI

struct RegisterOptionsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("welcome_bkg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
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
                
            }
            
            option(text: Constants.btn_logIn,
                   textColor: .colorDarkGrey,
                   color: .colorLightGrey) {
                
            }
        }
        .padding(.vertical, 100)
    }
    
    private var presentables: some View {
        ZStack {
            
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
        .frame(height: 55)
        .cornerRadius(22.5)
        .padding(.horizontal, 50)
    }
}

struct RegisterOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterOptionsView()
    }
}
