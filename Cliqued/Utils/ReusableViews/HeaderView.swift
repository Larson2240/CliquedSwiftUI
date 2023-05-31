//
//  HeaderView.swift
//  Cliqued
//
//  Created by Seraphim Kovalchuk on 24.05.2023.
//

import SwiftUI

struct HeaderView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var title: String
    var backButtonVisible: Bool
    
    var body: some View {
        ZStack {
            if backButtonVisible {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image("ic_back_black")
                    }
                    
                    Spacer()
                }
            }
            
            
            Text(title)
                .font(.themeBold(16))
                .foregroundColor(.colorSenderTextMsg)
        }
        .padding(.horizontal, 20)
        .padding(.top)
        .frame(height: 25)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Title", backButtonVisible: true)
    }
}
