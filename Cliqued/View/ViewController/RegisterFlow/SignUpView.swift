//
//  SignUpView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 23.05.2023.
//

import SwiftUI

struct SignUpView: View {
    enum FlowType {
        case signUp
        case signIn
    }
    
    @StateObject private var viewModel = SignUpViewModel()
    @State var currentFlow: FlowType
    @State private var forgotPasswordViewPresented = false
    
    var body: some View {
        ZStack {
            content
            
            presentables
        }
        .background(background)
        .navigationBarHidden(true)
    }
    
    private var content: some View {
        VStack {
            header
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: scaled(30)) {
                    Image("ic_registrationlogo")
                    
                    inputStack(title: Constants.label_email,
                               image: "ic_email",
                               binding: $viewModel.email,
                               isSecure: false)
                    
                    inputStack(title: Constants.label_password,
                               image: "ic_password",
                               binding: $viewModel.password,
                               isSecure: true)
                    
                    if currentFlow == .signUp {
                        inputStack(title: Constants.label_repeatPassword,
                                   image: "ic_password",
                                   binding: $viewModel.repeatPassword,
                                   isSecure: true)
                    }
                    
                    if currentFlow == .signIn {
                        loginConfigStack
                    }
                    
                    mainButton
                    
                    optionsStack
                }
            }
            .ignoresSafeArea()
        }
    }
    
    private var header: some View {
        HeaderView(title: currentFlow == .signUp ? Constants.screenTitle_signUp : "",
                   backButtonVisible: true)
    }
    
    private var background: some View {
        Image("background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width: screenSize.width, height: screenSize.height)
    }
    
    private func inputStack(title: String, image: String, binding: Binding<String>, isSecure: Bool) -> some View {
        VStack(alignment: .leading, spacing: scaled(14)) {
            Text(title)
                .font(.themeMedium(14))
                .foregroundColor(.colorDarkGrey)
            
            HStack(spacing: 12) {
                Image(image)
                
                if isSecure {
                    SecureField(title, text: binding)
                } else {
                    TextField(title, text: binding)
                        .keyboardType(.emailAddress)
                }
            }
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
    
    private var mainButton: some View {
        Button(action: { currentFlow == .signUp ? viewModel.callSignUpAPI() : viewModel.callSignInAPI() }) {
            ZStack {
                Color.theme
                
                Text(currentFlow == .signUp ? Constants.btn_signUp : Constants.btn_logIn)
                    .font(.themeBold(20))
                    .foregroundColor(.colorWhite)
            }
        }
        .frame(height: 60)
        .cornerRadius(30)
        .padding(.horizontal, 30)
    }
    
    private var optionsStack: some View {
        VStack {
            Image("ic_or")
            
            HStack(spacing: 16) {
                googleButton
                
                facebookButton
                
                appleButton
            }
            .padding(.top, 8)
            
            HStack(spacing: 4) {
                if currentFlow == .signUp {
                    Text(Constants.btn_alreadyHaveAccount.replacingOccurrences(of: Constants.btn_logIn, with: ""))
                        .font(.themeRegular(16))
                    
                    Button(action: { switchFlow() }) {
                        Text(Constants.btn_logIn)
                            .font(.themeBold(16))
                    }
                } else {
                    Text(Constants.btn_dontHaveAccount.replacingOccurrences(of: Constants.btn_signUp, with: ""))
                    
                    Button(action: { switchFlow() }) {
                        Text(Constants.btn_signUp)
                            .font(.themeBold(16))
                    }
                }
            }
            .foregroundColor(.colorDarkGrey)
            .padding(.top, 12)
            
            Color.colorLightGrey
                .frame(height: 1)
            
            Text(Constants.label_termsMessage)
                .font(.themeRegular(15))
                .foregroundColor(.colorMediumGrey)
                .padding(.leading, 8)
                .padding(.trailing)
            
        }
        .padding(.bottom, 40)
    }
    
    private var loginConfigStack: some View {
        HStack {
            Button(action: { viewModel.rememberMeSelected.toggle() }) {
                Image(viewModel.rememberMeSelected ? "ic_rememberme_selected" : "ic_rememberme_unselect")
                
                Text(Constants.btn_rememberMe)
            }
            
            Spacer()
            
            Button(action: { forgotPasswordViewPresented.toggle() }) {
                Text(Constants.btn_forgotPassword)
            }
        }
        .font(.themeMedium(15))
        .foregroundColor(.colorDarkGrey)
        .padding(.horizontal, 30)
    }
    
    private var googleButton: some View {
        Button(action: { viewModel.googleSignIn() }) {
            Image("ic_google")
        }
    }
    
    private var facebookButton: some View {
        Button(action: {  }) {
            Image("ic_facebook")
        }
    }
    
    private var appleButton: some View {
        Button(action: { viewModel.appleSignIn() }) {
            Image("ic_apple")
        }
    }
    
    private var presentables: some View {
        NavigationLink(destination: ForgotPasswordView(),
                       isActive: $forgotPasswordViewPresented,
                       label: EmptyView.init)
    }
    
    private func switchFlow() {
        withAnimation(.spring()) {
            if currentFlow == .signUp {
                currentFlow = .signIn
            } else {
                currentFlow = .signUp
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(currentFlow: .signUp)
    }
}
